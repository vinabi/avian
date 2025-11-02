%{
#include <stdio.h>
void print_token(const char* type, const char* text){
    printf("Line %d: %-20s → %s\n", yylineno, type, text);
}
%}

%option noyywrap
%option yylineno
%x COMMENT

WS      [ \t\r\f]+
NEWLINE \n
DIGIT   [0-9]
IDST    [A-Za-z_]
ID      {IDST}({IDST}|{DIGIT})*
INT     {DIGIT}+
FLOAT   {DIGIT}*"."{DIGIT}+
EXP     {DIGIT}+([eE][+-]?{DIGIT}+)
STR     \"[^\"]*\"

%%   

"//"[^\n]*                      ;
"/*"                            { BEGIN(COMMENT); }
<COMMENT>[^*\n]+                ;
<COMMENT>\n                     ;
<COMMENT>"*"+[^*/]*             ;
<COMMENT>"*"+"/"                { BEGIN(INITIAL); }
<COMMENT><<EOF>>                {
                                   fprintf(stderr,"Line %d: ERROR → unclosed comment\n", yylineno);
                                   BEGIN(INITIAL);
                                }

avn_if|avn_else|avn_for|avn_while|avn_break|avn_continue|avn_func|avn_return|avn_print|avn_scan|avn_int|avn_float|avn_str|avn_main|avn_end
                                { print_token("KEYWORD", yytext); }

"_++_"      { print_token("OP_INC", yytext); }
"_--_"      { print_token("OP_DEC", yytext); }
"_+_"       { print_token("OP_ADD", yytext); }
"_-_"       { print_token("OP_SUB", yytext); }
"_*_"       { print_token("OP_MUL", yytext); }
"_/_"       { print_token("OP_DIV", yytext); }

"_,_"       { print_token("PUNC_COMMA", yytext); }
";'"        { print_token("PUNC_SEMI_APOS", yytext); }
"::"        { print_token("PUNC_COLONPAIR", yytext); }

"="         { print_token("ASSIGN_OP", yytext); }
"+"         { print_token("PLUS_OP", yytext); }
"-"         { print_token("MINUS_OP", yytext); }
"*"         { print_token("MULT_OP", yytext); }
"/"         { print_token("DIV_OP", yytext); }
"("         { print_token("LPAREN", yytext); }
")"         { print_token("RPAREN", yytext); }
"{"         { print_token("LBRACE", yytext); }
"}"         { print_token("RBRACE", yytext); }
","         { print_token("COMMA", yytext); }
";'"         { print_token("SEMICOLON", yytext); }
"<"         { print_token("LT_OP", yytext); }
">"         { print_token("GT_OP", yytext); }
"=="        { print_token("EQ_OP", yytext); }
"!="        { print_token("NE_OP", yytext); }

{STR}       { print_token("STRING", yytext); }
{EXP}       { print_token("EXP_NUMBER", yytext); }
{FLOAT}     { print_token("FLOAT_NUMBER", yytext); }
{INT}       { print_token("INTEGER", yytext); }
{ID}        { print_token("IDENTIFIER", yytext); }

{WS}|{NEWLINE}   ;

.           { fprintf(stderr, "Line %d: ERROR → %s\n", yylineno, yytext); }

%%

int main(void){
    yylex();
    return 0;
}
