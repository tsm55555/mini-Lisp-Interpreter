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
%type<ival> STMTS STMT EXP DEFSTMT PRINTSTMT NUMOP LOGICALOP ANDOP OROP NOTOP FUN_EXP FUN_CALL IF_EXP
%type<ival> FUN_IDs FUN_BODY IDs FUN_NAME TEST_EXP THAN_EXP ELSE_EXP 
%type<ival> VARIABLE

%%
//grammar section
PROGRAM: STMTS {}
       ;

STMTS: STMT STMTS {}
     ;


STMT: EXP {}
    | DEFSTMT {}
    | PRINTSTMT {}

PRINTSTMT: printnum  EXP {}
         | printbool EXP {}
         ;

EXP:  bool {}
    | number {}
    | VARIABLE {}
    | NUMOP {}
    | LOGICALOP {}
    | FUN_EXP {}
    | FUN_CALL {}
    | IF_EXP {}
    ;

NUMOP: PLUS {}
     | MINUS {}
     | MULTIPLY {}
     | DIVIDE {}
     | MODULUS {}
     | GREATER {}
     | SMALLER {}
     | EQUAL {}
     ;

PLUS:     '(' '+' EXP EXP ')' {}
MINUS:    '(' '-' EXP EXP ')' {}
MULTIPLY: '(' '*' EXP EXP ')' {}
DIVIDE:   '(' '/' EXP EXP ')' {}
MODULUS:  '(' mod EXP EXP ')' {}
GREATER:  '(' '>' EXP EXP ')' {}
SMALLER:  '(' '<' EXP EXP ')' {}
EQUAL:    '(' '=' EXP EXP ')' {}

LOGICALOP: ANDOP {}
        |  OROP {}
        |  NOTOP {}
        ;

ANDOP: '(' and EXP EXP ')' {}
OROP:  '(' or  EXP EXP ')' {}
NOTOP: '(' not EXP EXP ')' {}

DEFSTMT: '(' def VARIABLE EXP ')' {}

VARIABLE: ID {}

FUN_EXP: '(' fun FUN_IDs FUN_BODY ')' {}

FUN_IDs: IDs {}
IDs: IDs VARIABLE {}
FUN_BODY: EXP {}
FUN_CALL: '(' FUN_EXP PARAMETERS ')' {}
        | '(' FUN_NAME PARAMETERS ')' {}
        ;
PARAMETERS: EXP {}
FUN_NAME: ID {}

IF_EXP: '(' if TEST_EXP THAN_EXP ELSE_EXP ')' {}
TEST_EXP: EXP {}
THAN_EXP: EXP {}
ELSE_EXP: EXP {}
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

