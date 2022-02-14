%{
#include <vslc.h>
%}

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program : 
      dummy0 { root = $$; }
    ;

dummy0 :
      dummy1 { $$ = $1; }
    | dummy2 { $$ = $1; }
    ;
dummy1 :
      RETURN NUMBER 
      { 
        node_init($$ = malloc(sizeof(node_t)), STATEMENT, NULL, 1, $2); // 2: NUMBER 
      }
    ;
dummy2 :
      VAR IDENTIFIER '+''=' NUMBER 
      {
        node_init($$ = malloc(sizeof(node_t)), STATEMENT, NULL, 2, $2, $5); // 2: IDENTIFIER, 5: NUMBER
      }
    | /* epsilon */ { return NULL; }
    ;
%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
