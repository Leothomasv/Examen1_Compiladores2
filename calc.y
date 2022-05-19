%{
    #include <cstdio>
    #include <map>
    #include <string>
    using namespace std;
    int yylex();
    extern int yylineno;
    map<string, float> variables;
    void yyerror(const char * s){
        fprintf(stderr, "Line %d, error: %s\n", yylineno, s);
    }
%}

%union{
   const char* string_t;
   int int_t;
   float float_t;
   bool bool_t;
}

%token <float_t> TK_FLOAT 
%token TK_PRINT TK_LET TK_BEGIN TK_END TK_IF TK_RETURN TK_ASSIGN
%token TK_PLUS TK_MINUS TK_DIV TK_MULTI TK_LESS TK_GREATER TK_EQUAL
%type <float_t> term factor expression assignation_statement logical_expression method_statement param_list param
%token <string_t> TK_ID
%%

program: statements
;

statements: statements statement
          | statement 
          ;

statement: print_statement
    | if_statement
    | method_statement
    | return_statement
    | assignation_statement
    ;

print_statement: TK_PRINT '(' param_list ')' ';' {printf("%f\n", $3);}
    | TK_PRINT '(' method_statement ')' ';' {printf("%f\n", $3);}
    ;

return_statement: TK_RETURN logical_expression ';'
    | TK_RETURN statement ';'
    ;
method_statement: TK_LET TK_ID '(' param_list ')' TK_ASSIGN TK_BEGIN statements TK_END
    ;

param_list: param_list ',' param_list
    | param
    ;

param: logical_expression
    ;

assignation_statement: TK_LET TK_ID TK_ASSIGN expression ';' {variables.insert(make_pair($2, $4));}
    ;

if_statement: TK_IF '(' logical_expression ')' TK_BEGIN statements TK_END
    ;

logical_expression: logical_expression TK_EQUAL logical_expression {$$ = (float)($1==$3);}
        | logical_expression TK_GREATER logical_expression {$$ = (float)($1>$3);}
        | logical_expression TK_LESS logical_expression {$$ = (float)($1<$3); }
        | expression {$$ = $1;}
        ;


expression: expression TK_PLUS factor {$$ = $1 + $3; }
    | expression TK_MINUS factor {$$ = $1 - $3; }
    | factor {$$ = $1; }
    ;

factor:factor TK_MULTI term {$$ = $1 * $3;}
    | factor TK_DIV term {$$ = $1 / $3;}
    | term {$$ = $1;}
    ;

term: TK_FLOAT {$$ = $1;}
    | TK_ID {if(variables.count($1)){$$ = variables.find($1)->second;} else {printf("Variable %s no esta declarada\n",$1); return 0;}}
    ;

%%
