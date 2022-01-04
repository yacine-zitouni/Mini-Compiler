%{
#include <stdio.h>
#include "routine.h"

extern int ligne;
extern int col;

int yyparse();
int yylex();
int typeIdf;
int typeVal;
int yyerror(char *s);

char temp[20];

%}


%union {
int entier;
float reel;
char* str;
}   
                 
%token mc_program mc_begin mc_op  mc_exp_logique  mc_pdec mc_pinst mc_end mc_define mc_for mc_while mc_do mc_endfor mc_if mc_else  mc_aff ':' ';' supEgal infEgal '<' '>' ',' '(' ')'  mc_pint mc_float mc_endif doubleEgal notEgal plus moins division multip  

%token<entier> entier
%token<float> reel
%token<str> mc_idf
%%

S: HEADER    PDEC PINST { printf (" \n programme syntaxiquement juste\n");YYACCEPT ;}
;
HEADER: mc_program mc_idf
;

PDEC:  mc_pdec DECS 
;
DECS : DECS DEC | DEC
;
DEC:  idfs ':' type  ';'  
    | mc_define type mc_idf '=' cst ';' 
	  {   if(!ajouter($3,typeIdf,1))
	      {      
		  printf("Erreur sémantique ligne %d, colonne %d: Variable '%s' déja déclarée",ligne,col,$3); YYABORT;
	      } 
	  }
;

type: mc_pint { typeIdf=0;}    |  mc_float { typeIdf=1;}
;
idfs: mc_idf   {   
		   if(!ajouter($1,typeIdf,0))
     		    {     printf("Erreur sémantique ligne %d, colonne %d : Variable '%s' déja déclarée",ligne,col,$1); YYABORT;   } 
 		 }

|  idfs ',' mc_idf  {   
		   if(!ajouter($3,typeIdf,0))
     		    {    printf("Erreur sémantique ligne %d, colonne %d  : Variable '%s' déja déclarée",ligne,col,$3); YYABORT;  } 
 		 }
;
PINST: mc_pinst mc_begin MAIN mc_end 
;
MAIN: INST | INST MAIN
;
INST: AFF | FOR | IF
;
AFF: mc_idf mc_aff val ';'
    { 
	if (!exist($1) )
	{
	    printf("Erreur sémantique ligne %d, colonne %d  : %s N'EST PAS DÉCLARÉ",ligne,col,$1); YYABORT;
        }
	else if ( estCst($1) )
	 { 
	     printf("Erreur sémantique ligne %d, colonne %d : Modification d'une constante %s",ligne,col,$1); YYABORT;
	 }
	 else if ( !compareType(typeVal,typeOf($1)))
	 {
	   printf("Erreur sémantique ligne %d, colonne %d  :Type Incompatible",ligne,col); YYABORT;
	 }	
     } 
;

IF : DO mc_endif| DO mc_else MAIN mc_endif
;
DO:mc_do MAIN mc_if ':' '(' COND ')' ;
COND: nb exp nb;

FOR: mc_for  mc_idf mc_aff cst mc_while cst mc_do MAIN  mc_endfor
;
val: nb | nb OP nb
;
OP : division|moins|plus|multip
;
nb: mc_idf {typeVal = typeOf($1);} | cst 
;
cst: reel {typeVal=1;} |entier  {typeVal =0;}
;
exp: doubleEgal | supEgal| infEgal |notEgal

%%

int yyerror(char* msg)
{printf("%s ligne %d et colonne %d",msg,ligne,col);
return 0;
}
int main()  {    

yyparse();  
afficher();
return 0;  
} 
