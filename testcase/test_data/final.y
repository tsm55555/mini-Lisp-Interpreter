%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
void yyerror(const char* message);
int not_equal = 0;
%}
%union {
    int ival;
    char* strval;
    struct op{
        int val;
        int add_op;
        int mul_op;
        int and_op;
        int or_op;
    }op;    
}

%token  printnum printbool '+' '-' '*' '/' '>' '<' '=' mod and or not def IF fun 
%token <strval> ID
%token <ival> number bool
%type<ival> STMTS STMT EXP DEFSTMT PRINTSTMT NUMOP LOGICALOP ANDOP OROP NOTOP FUN_EXP FUN_CALL IF_EXP
%type<ival> FUN_IDs FUN_BODY IDs FUN_NAME TEST_EXP THAN_EXP ELSE_EXP 
%type<ival> PLUS MINUS MULTIPLY DIVIDE MODULUS GREATER SMALLER EQUAL
%type<strval> VARIABLE 
%type<op> EXPs
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
         | '(' printbool EXP ')' { 
                                     if($3){
                                        printf("#t\n"); 
                                     }
                                     else {
                                        printf("#f\n");     
                                     }
                                 }   
         

EXPs: EXP EXPs { 
                    $$.add_op = $1 + $2.add_op;
                    $$.mul_op = $1 * $2.mul_op;
                    if($1 == $2.val){
                        $$.val = $1;
                    }
                    else{
                        $$.and_op = 0;
                        not_equal  = 1;
                    }
               }
    | EXP { 
             $$.val = $1;
             $$.add_op = $1;
             $$.mul_op = $1;
          }

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

PLUS:     '(' '+' EXP EXPs ')' { $$ = $3 + $4.add_op; printf("In add op $$: %d\n$4 add_op: %d\n", $$, $4.add_op); }
MINUS:    '(' '-' EXP EXP ')' { $$ = $3 - $4; printf("$3: %d\n$4: %d\n", $3, $4); }
MULTIPLY: '(' '*' EXP EXPs ')' { $$ = $3 * $4.mul_op; }
DIVIDE:   '(' '/' EXP EXP ')' { $$ = $3 / $4; }


MODULUS:  '(' mod EXP EXP ')'  { $$ = $3 % $4; }
GREATER:  '(' '>' EXP EXP ')' { 
                                    if($3 > $4){
                                        $$ = 1; 
                                    }
                                    else{
                                        $$ = 0;
                                    }
                               }
SMALLER:  '(' '<' EXP EXP ')' {
                                    if($3 < $4){
                                        $$ = 1;
                                    }
                                    else{
                                        $$ = 0;
                                    }
                               }
EQUAL:    '(' '=' EXP EXPs ')' {
                                    if(not_equal){
                                        $$ = 0;
                                        not_equal = 0;
                                    }
                                    else if($3 == $4.val){
                                        $$ = 1;
                                    }
                                    else{
                                        $$ = 0;
                                    }
                               }

LOGICALOP: ANDOP { $$ = $1; }
        |  OROP { $$ = $1; }
        |  NOTOP { $$ = $1; }

ANDOP: '(' and EXP EXPs ')' {
                                 if($4.and_op == 0){
                                     $$ = 0;
                                 }
                                 else if($3 == 1 && $4.val == 1){
                                     $$ = 1;
                                 }
                                 else{
                                     $$ = 0;
                                 }
                            }
     
OROP:  '(' or  EXP EXPs ')' {}
    
NOTOP: '(' not EXP ')' { 
                            if($3 == 0){
                                $$ = 1;
                            }
                            else{
                                $$ = 0;
                            }
                       }
     
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