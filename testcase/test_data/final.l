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
"print-num"	{return print-num;}
"print-bool"	{return print-bool;}
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
"if"	 {return if;}
{id}	 {yylval.strval=strdup(yytext); return ID;}
{bool}    	{   
			if(yytext == "#t"){
				yylval.ilval=1;
            }
			else{
				yylval.ilval=0;
            }
			return bool;}
{number} {yylval.ival=atoi(yytext); return NUMBER;}
"("|")"	 {return yytext[0];}
.|\n	 {}
%%