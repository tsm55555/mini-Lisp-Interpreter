%{
extern "C" {
int yylex();
int yyparse();
}
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string>
#include <map>
using namespace std;
void yyerror(const char* message);
int not_equal = 0;
map<string, int> my_variable;
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
        int is_variable;
        char* the_variable;
    }op;    
}

%token  printnum printbool '+' '-' '*' '/' '>' '<' '=' mod AND OR NOT def IF fun 
%token <strval> ID
%token <ival> number BOOL
%type<ival> STMTS STMT DEFSTMT PRINTSTMT NUMOP LOGICALOP ANDOP OROP NOTOP FUN_EXP FUN_CALL IF_EXP
%type<ival> FUN_IDs FUN_BODY IDs FUN_NAME TEST_EXP THAN_EXP ELSE_EXP 
%type<ival> PLUS MINUS MULTIPLY DIVIDE MODULUS GREATER SMALLER EQUAL
%type<strval> VARIABLE 
%type<op> EXP EXPs
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

PRINTSTMT: '(' printnum  EXP ')' { printf("%d\n", $3.val); }
         | '(' printbool EXP ')' { 
                                     if($3.val){
                                        printf("#t\n"); 
                                     }
                                     else {
                                        printf("#f\n");     
                                     }
                                 }   
         

EXPs: EXP EXPs { 
                    $$.add_op = $1.val + $2.add_op;
                    $$.mul_op = $1.val * $2.mul_op;
                    $$.and_op = 1;
                    $$.val = $2.val;
                    if($1.val == $2.val){
                        $$.val = $1.val;
                    }
                    else{
                        $$.and_op = 0;
                        not_equal  = 1;
                    }

                    if($1.val == 1 || $2.val == 1) {
                        $$.or_op = 1;
                    }
                    else{
                        $$.or_op = 0;
                    }
               }
    | EXP { 
             $$.val = $1.val;
             $$.add_op = $1.val;
             $$.mul_op = $1.val;
             $$.and_op = 1;
             $$.or_op = $1.val;
          }

EXP:  BOOL { $$.val = $1; }
    | number { $$.val = $1; }
    | VARIABLE { $$.val = my_variable[$1]; $$.is_variable = 1; $$.the_variable = $1; }
    | NUMOP { $$.val = $1; }
    | LOGICALOP { $$.val = $1; }
    | FUN_EXP { $$.val = $1; }
    | FUN_CALL { $$.val = $1; }
    | IF_EXP { $$.val = $1; }
    ;

NUMOP: PLUS {}
     | MINUS {}
     | MULTIPLY {}
     | DIVIDE {}
     | MODULUS {}
     | GREATER {}
     | SMALLER {}
     | EQUAL {}

PLUS:     '(' '+' EXP EXPs ')' {    
                                    $$ = $3.val + $4.add_op; 
                                    not_equal=0; 
                                    if($3.is_variable){
                                        my_variable[$3.the_variable] = $$;
                                    }
                               }

MINUS:    '(' '-' EXP EXP ')'  { 
                                    $$ = $3.val - $4.val; 
                                    if($3.is_variable){
                                        my_variable[$3.the_variable] = $$;
                                    }
                               }

MULTIPLY: '(' '*' EXP EXPs ')' { 
                                    $$ = $3.val * $4.mul_op; 
                                    not_equal=0;
                                    if($3.is_variable){
                                        my_variable[$3.the_variable] = $$;
                                    }

                               }

DIVIDE:   '(' '/' EXP EXP ')'  { 
                                    $$ = $3.val / $4.val;
                                    if($3.is_variable){
                                        my_variable[$3.the_variable] = $$;
                                    } 
                               }


MODULUS:  '(' mod EXP EXP ')'  { 
                                    $$ = $3.val % $4.val;
                                    if($3.is_variable){
                                        my_variable[$3.the_variable] = $$;
                                    } 
                               }

GREATER:  '(' '>' EXP EXP ')'  { 
                                    if($3.val > $4.val){
                                        $$ = 1; 
                                    }
                                    else{
                                        $$ = 0;
                                    }
                               }

SMALLER:  '(' '<' EXP EXP ')'  {
                                    if($3.val < $4.val){
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
                                    else if($3.val == $4.val){
                                        $$ = 1;
                                    }
                                    else{
                                        $$ = 0;
                                    }
                               }

LOGICALOP: ANDOP { $$ = $1; }
        |  OROP  { $$ = $1; }
        |  NOTOP { $$ = $1; }

ANDOP: '(' AND EXP EXPs ')' {
                                 if($4.and_op == 0){
                                     $$ = 0;
                                 }
                                 else if($3.val == 1 && $4.val == 1){
                                     $$ = 1;
                                 }
                                 else{
                                     $$ = 0;
                                 }
                                 not_equal=0;
                            }
     
OROP:  '(' OR  EXP EXPs ')' {
                                 if($3.val == 1 || $4.or_op == 1){
                                     $$ = 1;
                                 }
                                 else{
                                     $$ = 0;
                                 }
                                 not_equal=0;
                            }
    
NOTOP: '(' NOT EXP ')' { 
                            if($3.val == 0){
                                $$ = 1;
                            }
                            else{
                                $$ = 0;
                            }
                       }
     
DEFSTMT: '(' def VARIABLE EXP ')' {
                                       if ( my_variable.find($3) == my_variable.end() ) {
                                            my_variable[$3] = $4.val;
                                            //printf("define %s as %d\n", $3, my_variable[$3]);
                                        } 
                                        else {
                                            cout << "Redefining is not allowed" << endl;
                                            return 0;
                                        }
                                  } 

VARIABLE: ID { $$ = $1; }
        
IF_EXP: '(' IF TEST_EXP THAN_EXP ELSE_EXP ')' {
                                                    if($3){
                                                        $$ = $4;
                                                    }
                                                    else{
                                                        $$ = $5;
                                                    }
                                              }
TEST_EXP: EXP { $$ = $1.val ;}
        ;
THAN_EXP: EXP { $$ = $1.val ;}
        ;
ELSE_EXP: EXP { $$ = $1.val ;}
        ;
        
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
        
PARAMETERS: EXP PARAMETERS{}
          |
          ;
FUN_NAME: ID {}
        ;

%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
}

int main() {
        yyparse();
        return(0);
}