%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}
%union {
    int ival;
    char* strval;
}

%token  printnum printbool add sub mul div mod big small equ and or not def if fun 
%token <strval> ID
%token <ival> NUMBER BOOL
%type STMTS STMT EXP DEFSTMT PRINTSTMT

%%
//grammar section
PROGRAM: STMTS

STMTS: STMT STMTS
     ;


STMT: EXP 
    | DEFSTMT 
    | PRINTSTMT

PRINTSTMT: printnum EXP
         | printbool EXP

EXP: 
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

