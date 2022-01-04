
%{
#include <stdio.h>
#include<string.h>
#include "syntaxe.tab.h"




int ligne=1;
int col=0;




%}

chiffre	[0-9]
op \+|-|\*|\/
exp >=|<=|==|>|<
exp_logique &|\||!

entier (\+|-)?[1-9]{chiffre}*
reel {entier}.{chiffre}+
idf  [a-zA-Z]([a-zA-Z]|[0-9])*

%%
PROGRAM {return mc_program; col=col+yyleng;}
ENDIF {return mc_endif; col=col+yyleng;}
PDEC {return mc_pdec; col=col+yyleng;}
PINST {return mc_pinst; col=col+yyleng;}
Pint {return mc_pint; col=col+yyleng;}
Pfloat {return mc_float; col=col+yyleng;}
BEGIN {return mc_begin; col=col+yyleng;}
END {return mc_end;col=col+yyleng;}

@define {return mc_define; col=col+yyleng;}
FOR {return mc_for; col=col+yyleng;}
WHILE {return mc_while; col=col+yyleng;}
DO {return mc_do; col=col+yyleng;}
ENDFOR {return mc_endfor; col=col+yyleng;}
IF {return mc_if ; col=col+yyleng;}
ELSE {return mc_else; col=col+yyleng;}
{op} {
	col = col + yyleng;
	if(strcmp(yytext,"/")==0)
		return division;
	else if(strcmp(yytext,"*")==0)
			return multip;
		else if(strcmp(yytext,"+")==0)
				return plus;
			else if(strcmp(yytext,"-")==0)
					return moins;
}
{exp} {
	col = col + yyleng;
	if(strcmp(yytext,">")==0)
		return '>';
	else if(strcmp(yytext,"<")==0)
			return '<';
		else if(strcmp(yytext,"<=")==0)
				return infEgal;
			else if(strcmp(yytext,">=")==0)
					return supEgal;
				else if(strcmp(yytext,"==")==0)
						return doubleEgal;
					else if(strcmp(yytext,"!=")==0)
							return notEgal;
}
{exp_logique} {return mc_exp_logique; col=col+1;}
{entier} {if (atoi(yytext)>=-32768 && atoi(yytext)<=32767) {yylval.entier=atoi(yytext);  return entier;} else printf("Erreur lexical: nombre trop grand, la ligne %d et colonne %d",ligne,col); col=col+yyleng;}
{reel} {yylval.reel=atoi(yytext);  return reel; col=col+yyleng;}
{idf} {if (yyleng<=12) { yylval.str=strdup(yytext);   return mc_idf;}
    else {printf("erreur lexical: IDF trop long ");}col=col+yyleng;}

"<--" { return mc_aff;col=col+yyleng;}
[ \t ] col++;
[{}()";:,=] {return yytext[0];col=col+yyleng;}
\n {ligne++;col=0;}
"//".*                                    { /* RIEN À FAIRE */ }
"/*"[^*]*[*]+([^*/][^*]*[*]+)*[/]       { /* RIEN À FAIRE */ }
.	{printf("\nErreur lexical ligne %d, colonne %d : Entitée non reconnue",ligne,col);}


%%

int yywrap(void)
{
return 0;
}



