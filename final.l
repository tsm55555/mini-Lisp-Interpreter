%option noyywrap
%{
extern "C" {
int yylex();
}
#include "final.tab.hh"
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
"and"	 {return AND;}
"or"	 {return OR;}
"not"	 {return NOT;}
"define" {return def;}
"lambda"|"fun"	 {return fun;}
"if"	 {return IF;}
{id}	 {yylval.strval = strdup(yytext); return ID;}
{bool}    	{   
			if(strcmp( yytext, "#t") == 0){
				yylval.ival=1;
            }
			else{
				yylval.ival=0;
            }
			return BOOL;}
{number} {yylval.ival = atoi(yytext); return number;}
"("|")"	 {return yytext[0];}
\t {}
\r {}
.|\n	 {}
%%