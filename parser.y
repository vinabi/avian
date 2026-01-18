%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern char* yytext;

int yylex(void);
void yyerror(const char *s);
%}

/* ===== Tokens from scanner.l ===== */
%token AVN_INT AVN_IF AVN_ELSE AVN_WHILE AVN_PRINT
%token ID NUM
%token ASSIGN
%token LPAREN RPAREN LBRACE RBRACE SEMI

%start P

%%

/* ===== Grammar ===== */

P   : B
      {
        printf("Syntax analysis successful\n");
      }
    ;

B   : LBRACE SL RBRACE
    ;

SL  : S SL
    | /* epsilon */
    ;

S   : D
    | A
    | IF
    | WH
    | OUT
    ;

D   : AVN_INT ID SEMI
    ;

A   : ID ASSIGN NUM SEMI
    ;

IF  : AVN_IF LPAREN NUM RPAREN B
    | AVN_IF LPAREN NUM RPAREN B AVN_ELSE B
    ;

WH  : AVN_WHILE LPAREN NUM RPAREN B
    ;

OUT : AVN_PRINT ID SEMI
    ;

%%

void yyerror(const char *s)
{
    printf(
        "Syntax Error at line %d: %s, found '%s'\n",
        yylineno,
        s,
        yytext
    );
}
