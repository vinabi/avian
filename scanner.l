%{
#include <stdio.h>
void print_token(const char* type, const char* text){ printf("%s\t%s\n", type, text); }
%}

%option noyywrap

WS      [ \t\r\f]+
NEWLINE \n
DIGIT   [0-9]
IDST    [A-Za-z_]
ID      {IDST}({IDST}|{DIGIT})*
INT     {DIGIT}+
STR     \"[^\"]*\"

%%

avn_if|avn_else|avn_for|avn_while|avn_break|avn_continue|avn_func|avn_return|avn_print|avn_scan|avn_int|avn_float|avn_str|avn_main|avn_end    { print_token("KEYWORD", yytext); }

"_++_"      { print_token("OP_INC", yytext); }
"_--_"      { print_token("OP_DEC", yytext); }
"_+_"       { print_token("OP_ADD", yytext); }
"_-_"       { print_token("OP_SUB", yytext); }
"_*_"       { print_token("OP_MUL", yytext); }
"_/_"       { print_token("OP_DIV", yytext); }
"("         { print_token("PUNC_LPAREN", yytext); }
")"         { print_token("PUNC_RPAREN", yytext); }
"{"         { print_token("PUNC_LBRACE", yytext); }
"}"         { print_token("PUNC_RBRACE", yytext); }
"="         { print_token("OP_ASSIGN", yytext); }

"_,_"       { print_token("PUNC_COMMA", yytext); }
";'"        { print_token("PUNC_SEMI_APOS", yytext); }   /* replaces ; */
"::"        { print_token("PUNC_COLONPAIR", yytext); }   /* new extra punctuation */

{STR}       { print_token("STRING", yytext); }
{INT}       { print_token("INTEGER", yytext); }
{ID}        { print_token("IDENTIFIER", yytext); }

{WS}|{NEWLINE}   ;

.           { fprintf(stderr, "LEX_ERROR\tUnrecognized:%s\n", yytext); }

%%

int main(void){
    yylex();
    return 0;
}

