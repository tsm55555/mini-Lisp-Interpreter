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
"print-num"	{return PRINTNUM;}
"print-bool"	{return PRINTBOOL;}
"#t"|"#f"	{   
			if(strcmp(yytext,"#t")==0)
				yylval.boolval=1;
			else
				yylval.boolval=0;
			return BOOL;}
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