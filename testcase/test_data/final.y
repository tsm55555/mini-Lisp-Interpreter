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
%type<ival> VARIABLE EXPs EXPs_P EXPs_M PLUS MINUS MULTIPLY DIVIDE MODULUS

%%
//grammar section
PROGRAM: STMTS {}
       ;

STMTS: STMT STMTS {}
     | STMT {}
     ;


STMT: EXP {}
    | DEFSTMT {}
    | PRINTSTMT {}
    ;

PRINTSTMT: '(' printnum  EXP ')' { printf("%d\n", $3); }
         | '(' printbool EXP ')' { printf("%d\n", $3); }
         

EXPs: EXP EXPs { $$ = $2;}
    | EXP { $$ = $1;}


EXP:  bool { $$ = $1; }
    | number { $$ = $1; }
    | VARIABLE {}
    | NUMOP { $$ = $1; }
    | LOGICALOP { $$ = $1; }
    | FUN_EXP { $$ = $1; }
    | FUN_CALL { $$ = $1; }
    | IF_EXP { $$ = $1; }
    ;

NUMOP: PLUS {}
     | MINUS {}
     | MULTIPLY {}
     | DIVIDE {}
     | MODULUS {}
     | GREATER {}
     | SMALLER {}
     | EQUAL {}

PLUS:     '(' '+' EXP EXPs_P ')' { $$ = $3 + $4; }
MINUS:    '(' '-' EXP EXPs ')' { $$ = $3 - $4; }
EXPs_P: EXP EXPs { $$ = $1 + $2;}
    | EXP { $$ = $1;}

MULTIPLY: '(' '*' EXP EXPs_M ')' { $$ = $3 * $4; }
DIVIDE:   '(' '/' EXP EXPs ')' { $$ = $3 / $4; }
EXPs_M: EXP EXPs { $$ = $1 * $2;}
    | EXP { $$ = $1;}

MODULUS:  '(' mod EXP EXP ')' { $$ = $3 % $4; }
GREATER:  '(' '>' EXP EXPs ')' {}
SMALLER:  '(' '<' EXP EXPs ')' {}
EQUAL:    '(' '=' EXP EXPs ')' {}

LOGICALOP: ANDOP {}
        |  OROP {}
        |  NOTOP {}

ANDOP: '(' and EXP EXPs ')' {}
     
OROP:  '(' or  EXP EXPs ')' {}
    
NOTOP: '(' not EXP ')' {}
     
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

