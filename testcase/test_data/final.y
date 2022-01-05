%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//tests
%}
%union {
    int ival;
    char* strval;
}

%token  printnum printbool '+' '-' '*' '/' mod '>' '<' '=' and or not def if fun 
%token <strval> ID
%token <ival> number bool
%type<ival> STMTS STMT EXP DEFSTMT PRINTSTMT NUMOP LOGICALOP ANDOP OROP NOTOP FUNEXP FUNCALL IFEXP
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

PLUS:     '(' '+' EXP EXP ')'
MINUS:    '(' '-' EXP EXP ')'
MULTIPLY: '(' '*' EXP EXP ')'
DIVIDE:   '(' '/' EXP EXP ')'
MODULUS:  '(' mod EXP EXP ')'
GREATER:  '(' '>' EXP EXP ')'
SMALLER:  '(' '<' EXP EXP ')'
EQUAL:    '(' '=' EXP EXP ')'

LOGICALOP: ANDOP 
        |  OROP 
        |  NOTOP
ANDOP: '(' and EXP EXP ')'
OROP:  '(' or  EXP EXP ')'
NOTOP: '(' not EXP EXP ')'
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

