%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}
%union {
    int ival;
    char* strval;
}

%token  printnum printbool '+' '-' '*' '/' mod '>' '<' '=' and or not def if fun 
%token <strval> ID
%token <ival> number bool
%type<ival> STMTS STMT EXP DEFSTMT PRINTSTMT NUMOP LOGICALOP FUNEXP FUNCALL IFEXP
%type<ival> VARIABLE

%%
//grammar section
PROGRAM: STMTS

STMTS: STMT STMTS
     ;


STMT: EXP 
    | DEFSTMT 
    | PRINTSTMT
    ;

PRINTSTMT: printnum EXP
         | printbool EXP
         ;
EXP: bool 
    | number 
    | VARIABLE 
    | NUMOP 
    | LOGICALOP
    | FUNEXP 
    | FUNCALL 
    | IFEXP
    ;

NUMOP: PLUS 
     | MINUS 
     | MULTIPLY 
     | DIVIDE 
     | MODULUS 
     | GREATER
     | SMALLER 
     | EQUAL
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

