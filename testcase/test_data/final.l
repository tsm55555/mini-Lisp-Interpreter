%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
%}
digit	[0-9]
letter	[a-z]
number	0|[1-9]{digit}*|-[1-9]{digit}*
id	{letter}({letter}|{digit}|-)*
%%
"print-num"	{return print-num;}
"print-bool"	{return print-bool;}
"#t"|"#f"	{   
			if(yytext == "#t"){
				yylval.ilval=1;
            }
			else{
				yylval.ilval=0;
            }
			return bool;}
{number} {yylval.ival=atoi(yytext); return NUMBER;}
"+"	     {return add;}
"-"	     {return sub;}
"*"	     {return mul;}
"/"	     {return div;}
"mod"    {return mod;}
">"	     {return big;}
"<"	     {return small;}
"="	     {return equ;}
"and"	 {return and;}
"or"	 {return or;}
"not"	 {return not;}
"define" {return def;}
"fun"	 {return fun;}
"if"	 {return if;}
{id}	 {yylval.strval=strdup(yytext); return ID;}
"("|")"	 {return yytext[0];}
.|\n	 {}
%%