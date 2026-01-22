%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern char* yytext;

int yylex(void);
void yyerror(const char *s);
%}

/* ===== Tokens from scanner.l ===== */

/* Keywords - All Phase 1 keywords */
%token AVN_INT AVN_IF AVN_ELSE AVN_WHILE AVN_PRINT
%token AVN_FOR AVN_BREAK AVN_CONTINUE AVN_FUNC AVN_RETURN
%token AVN_CIN AVN_COUT AVN_SCAN AVN_FLOAT AVN_STR AVN_MAIN AVN_END

/* Identifiers and Literals */
%token ID NUM STRING

/* Assignment Operator */
%token ASSIGN

/* Delimiters */
%token LPAREN RPAREN LBRACE RBRACE SEMI COMMA

/* Avian Custom Operators */
%token OP_ADD OP_SUB OP_MUL OP_DIV OP_INC OP_DEC

/* Avian Custom Punctuations */
%token PUNC_COMMA PUNC_SEMI_APOS PUNC_COLONPAIR

/* Comparison Operators */
%token LT_OP GT_OP EQ_OP NE_OP

/* Stream Operators */
%token EXE_OP INS_OP

%left OP_ADD OP_SUB
%left OP_MUL OP_DIV

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
    | AVN_INT ID ASSIGN E SEMI
    ;

A   : ID ASSIGN E SEMI
    ;

IF  : AVN_IF LPAREN E RPAREN B
    | AVN_IF LPAREN E RPAREN B AVN_ELSE B
    ;

WH  : AVN_WHILE LPAREN E RPAREN B
    ;

OUT : AVN_PRINT ID SEMI
    | AVN_PRINT E SEMI
    ;

E   : E OP_ADD E
    | E OP_SUB E
    | E OP_MUL E
    | E OP_DIV E
    | LPAREN E RPAREN
    | ID
    | NUM
    | STRING
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

int main(void)
{
    return yyparse();
}