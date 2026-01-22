%{
#include <stdio.h>
#include "y.tab.h"

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

\"[^\"]*$                       { fprintf(stderr, "Line %d: ERROR → unterminated string: %s\n", yylineno, yytext); }
\"[^\"]*                        { fprintf(stderr, "Line %d: ERROR → unterminated string at EOF\n", yylineno); }

{DIGIT}+{IDST}({IDST}|{DIGIT})* { fprintf(stderr, "Line %d: ERROR → invalid identifier (cannot start with digit): %s\n", yylineno, yytext); }

{DIGIT}+"."{DIGIT}*{IDST}+({IDST}|{DIGIT})* { fprintf(stderr, "Line %d: ERROR → invalid number (malformed float): %s\n", yylineno, yytext); }

avn_int     { print_token("KEYWORD", yytext); return AVN_INT; }
avn_if      { print_token("KEYWORD", yytext); return AVN_IF; }
avn_else    { print_token("KEYWORD", yytext); return AVN_ELSE; }
avn_while   { print_token("KEYWORD", yytext); return AVN_WHILE; }
avn_print   { print_token("KEYWORD", yytext); return AVN_PRINT; }
avn_for     { print_token("KEYWORD", yytext); return AVN_FOR; }
avn_break   { print_token("KEYWORD", yytext); return AVN_BREAK; }
avn_continue { print_token("KEYWORD", yytext); return AVN_CONTINUE; }
avn_func    { print_token("KEYWORD", yytext); return AVN_FUNC; }
avn_return  { print_token("KEYWORD", yytext); return AVN_RETURN; }
avn_cin     { print_token("KEYWORD", yytext); return AVN_CIN; }
avn_cout    { print_token("KEYWORD", yytext); return AVN_COUT; }
avn_scan    { print_token("KEYWORD", yytext); return AVN_SCAN; }
avn_float   { print_token("KEYWORD", yytext); return AVN_FLOAT; }
avn_str     { print_token("KEYWORD", yytext); return AVN_STR; }
avn_main    { print_token("KEYWORD", yytext); return AVN_MAIN; }
avn_end     { print_token("KEYWORD", yytext); return AVN_END; }

"_++_"      { print_token("OP_INC", yytext); return OP_INC; }
"_--_"      { print_token("OP_DEC", yytext); return OP_DEC; }
"_+_"       { print_token("OP_ADD", yytext); return OP_ADD; }
"_-_"       { print_token("OP_SUB", yytext); return OP_SUB; }
"_*_"       { print_token("OP_MUL", yytext); return OP_MUL; }
"_/_"       { print_token("OP_DIV", yytext); return OP_DIV; }

"_,_"       { print_token("PUNC_COMMA", yytext); return PUNC_COMMA; }
";'"        { print_token("PUNC_SEMI_APOS", yytext); return PUNC_SEMI_APOS; }
"::"        { print_token("PUNC_COLONPAIR", yytext); return PUNC_COLONPAIR; }

"="         { print_token("ASSIGN_OP", yytext); return ASSIGN; }
"("         { print_token("LPAREN", yytext); return LPAREN; }
")"         { print_token("RPAREN", yytext); return RPAREN; }
"{"         { print_token("LBRACE", yytext); return LBRACE; }
"}"         { print_token("RBRACE", yytext); return RBRACE; }
","         { print_token("COMMA", yytext); return COMMA; }
";"        { print_token("SEMICOLON", yytext); return SEMI; }
"<"         { print_token("LT_OP", yytext); return LT_OP; }
">"         { print_token("GT_OP", yytext); return GT_OP; }
"=="        { print_token("EQ_OP", yytext); return EQ_OP; }
"!="        { print_token("NE_OP", yytext); return NE_OP; }

"<<"        { print_token("EXE_OP", yytext); return EXE_OP; }
">>"        { print_token("INS_OP", yytext); return INS_OP; }

{STR}       { print_token("STRING", yytext); return STRING; }
{EXP}       { print_token("EXP_NUMBER", yytext); return NUM; }
{FLOAT}     { print_token("FLOAT_NUMBER", yytext); return NUM; }
{INT}       { print_token("INTEGER", yytext); return NUM; }
{ID}        { print_token("IDENTIFIER", yytext); return ID; }

{WS}|{NEWLINE}   ;

"_"[+\-*/,]{3,}"_"      { fprintf(stderr, "Line %d: ERROR → malformed operator (too many operator symbols): %s\n", yylineno, yytext); }
"_"[+\-*/,]{1,2}        { fprintf(stderr, "Line %d: ERROR → incomplete operator (missing closing underscore '_'): %s\n", yylineno, yytext); }
[+\-]{2}"_"             { fprintf(stderr, "Line %d: ERROR → incomplete operator (missing opening underscore '_'): %s\n", yylineno, yytext); }
"_"[+\-*/,]{1,2}[^_\n \t]    { fprintf(stderr, "Line %d: ERROR → malformed operator (invalid closing): %s\n", yylineno, yytext); }
"_"[^+\-*/,_\n \t]+     { fprintf(stderr, "Line %d: ERROR → invalid operator pattern (unknown symbols after '_'): %s\n", yylineno, yytext); }

"+"                     { fprintf(stderr, "Line %d: ERROR → invalid operator '+' (use '_+_' instead)\n", yylineno); }
"-"                     { fprintf(stderr, "Line %d: ERROR → invalid operator '-' (use '_-_' instead)\n", yylineno); }
"*"                     { fprintf(stderr, "Line %d: ERROR → invalid operator '*' (use '_*_' instead)\n", yylineno); }
"/"                     { fprintf(stderr, "Line %d: ERROR → invalid operator '/' (use '_/_' instead)\n", yylineno); }

":"                     { fprintf(stderr, "Line %d: ERROR → incomplete punctuation (expected double colon '::'): %s\n", yylineno, yytext); }
"!"                     { fprintf(stderr, "Line %d: ERROR → incomplete operator (expected '!=' not standalone '!'): %s\n", yylineno, yytext); }
"="{2,}                 { fprintf(stderr, "Line %d: ERROR → malformed equality operator (too many '=' symbols): %s\n", yylineno, yytext); }
"!"{2,}                 { fprintf(stderr, "Line %d: ERROR → invalid operator (multiple '!' symbols): %s\n", yylineno, yytext); }

.           { fprintf(stderr, "Line %d: ERROR → invalid character: '%s' (ASCII: %d)\n", yylineno, yytext, (int)yytext[0]); }

%%
