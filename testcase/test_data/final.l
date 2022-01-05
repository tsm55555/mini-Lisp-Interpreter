%option noyywrap
%{
#include "final.tab.h"
#include <stdio.h>
%}
digit	[0-9]
letter	[a-z]
number	0|[1-9]{digit}*|-[1-9]{digit}*
bool    "#t"|"#f"
id	{letter}({letter}|{digit}|-)*
%%
"print-num"	{return printnum;}
"print-bool"	{return printbool;}
"+"	     {return '+';}
"-"	     {return '-';}
"*"	     {return '*';}
"/"	     {return '/';}
"mod"    {return mod;}
">"	     {return '>';}
"<"	     {return '<';}
"="	     {return '=';}
"and"	 {return and;}
"or"	 {return or;}
"not"	 {return not;}
"define" {return def;}
"fun"	 {return fun;}
"if"	 {return IF;}
{id}	 {return ID;}
{bool}    	{   
			if(strcmp( yytext, "#t") == 0){
				yylval.ival=1;
            }
			else{
				yylval.ival=0;
            }
			return bool;}
{number} {return number;}
"("|")"	 {return yytext[0];}
\t {}
\n {}
\r {}
.|\n	 {}
%%