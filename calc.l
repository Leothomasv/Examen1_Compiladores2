%option yylineno
%option noyywrap

%{
    #include "tokens.h"
%}

DIGIT [0-9]

%%
[ \t\n\r] {/*ignore*/ }
"print" { return TK_PRINT; }
"let" {return TK_LET;}
"begin" {return TK_BEGIN;}
"end" {return TK_END;}
"if" {return TK_IF;}
"return" {return TK_RETURN;}
"=" {return TK_ASSIGN;}
"+" {return TK_PLUS;}
"-" {return TK_MINUS;}
"/" {return TK_DIV;}
"*" {return TK_MULTI;}
"<" {return TK_LESS;}
">" {return TK_GREATER;}
"==" {return TK_EQUAL;}
"(" { return '('; }
")" { return ')'; }
";" { return ';'; }

[a-zA-Z]({DIGIT}|[a-zA-Z_0-9]|_)* { yylval.string_t = strdup(yytext); return TK_ID;}
{DIGIT}+"."{DIGIT}+ { yylval.float_t = atof(yytext); return TK_FLOAT; }


. {printf("Invalid character %c, line %d\n", yytext[0], yylineno); yyterminate();}
%%