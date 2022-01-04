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

%token  printnum printbool add sub mul div mod big small equ and or not def if fun 
%token <strval> ID
%token <ival> NUMBER BOOL


%%
//grammar section
PROGRAM: STMT
%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

