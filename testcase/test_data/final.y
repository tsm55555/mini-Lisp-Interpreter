%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
void yyerror(const char* message);
//tests
%}
%union {
    int ival;
    char* strval;
}

%token  printnum printbool '+' '-' '*' '/' mod '>' '<' '=' and or not def IF fun 
%token <strval> ID
%token <ival> number bool
%type<ival> STMTS STMT EXP DEFSTMT PRINTSTMT NUMOP LOGICALOP ANDOP OROP NOTOP FUN_EXP FUN_CALL IF_EXP
%type<ival> FUN_IDs FUN_BODY IDs FUN_NAME TEST_EXP THAN_EXP ELSE_EXP 
%type<ival> VARIABLE

%%
//grammar section
PROGRAM: STMTS {printf("hello 1");}
       ;

STMTS: STMT STMTS {printf("hello 2");}
     | STMT {printf("hello 3");}
     ;


STMT: EXP {}
    | DEFSTMT {}
    | PRINTSTMT {}
    ;

PRINTSTMT: printnum  EXP { printf("hello");}
         | printbool EXP {}
         

EXPs: EXP EXPs {}
    | EXP
    
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

PLUS:     '(' '+' EXP EXPs ')' {}
MINUS:    '(' '-' EXP EXPs ')' {}
MULTIPLY: '(' '*' EXP EXPs ')' {}
DIVIDE:   '(' '/' EXP EXPs ')' {}
MODULUS:  '(' mod EXP EXPs ')' {}
GREATER:  '(' '>' EXP EXPs ')' {}
SMALLER:  '(' '<' EXP EXPs ')' {}
EQUAL:    '(' '=' EXP EXPs ')' {}

LOGICALOP: ANDOP {}
        |  OROP {}
        |  NOTOP {}

ANDOP: '(' and EXP EXPs ')' {}
     ;
OROP:  '(' or  EXP EXPs ')' {}
    ;
NOTOP: '(' not EXP ')' {}
     ;
DEFSTMT: '(' def VARIABLE EXP ')' {}
       ;

VARIABLE: ID { $$ = $1; }
        
FUN_EXP: '(' fun FUN_IDs FUN_BODY ')' {}
       

FUN_IDs: '(' IDs ')' {}

IDs: ID IDs {}
   |
   ;

FUN_BODY: EXP {}
        ;
FUN_CALL: '(' FUN_EXP PARAMETERS ')' {}
        | '(' FUN_NAME PARAMETERS ')' {}
        ;
        
PARAMETERS: EXP {}
          ;
FUN_NAME: ID {}
        ;

IF_EXP: '(' IF TEST_EXP THAN_EXP ELSE_EXP ')' {}
      ;
TEST_EXP: EXP { $$ = $1 ;}
        ;
THAN_EXP: EXP { $$ = $1 ;}
        ;
ELSE_EXP: EXP { $$ = $1 ;}
        ;
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}

