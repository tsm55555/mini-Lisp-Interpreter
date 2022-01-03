%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

%}
%union {
    int ival;
    char* strval;
}
%%
//grammar section

%%
    
void yyerror(const char* message) {
    printf("syntax error\n");
};

