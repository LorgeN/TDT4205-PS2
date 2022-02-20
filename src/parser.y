%{
#include <vslc.h>

#define MAKE_NODE(var, type, data, n_children, ...) \
node_init(var = malloc(sizeof(node_t)), type, data, n_children, ##__VA_ARGS__)

#define EMPTY_NODE(var, type, data) MAKE_NODE(var, type, data, 0)

%}
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc IF THEN
%nonassoc ELSE

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING

%%
program : 
  global_list { 
    MAKE_NODE(root, PROGRAM, NULL, 1, $1);
  };

global_list :
  global {
    MAKE_NODE($$, GLOBAL_LIST, NULL, 1, $1);
  }
| global_list global {
    MAKE_NODE($$, GLOBAL_LIST, NULL, 2, $1, $2);
  };

global :
  function {
    MAKE_NODE($$, GLOBAL, NULL, 1, $1);
  }
| declaration {
    MAKE_NODE($$, GLOBAL, NULL, 1, $1);
  };

statement_list :
  statement {
    MAKE_NODE($$, STATEMENT_LIST, NULL, 1, $1);
  }
| statement_list statement {
    MAKE_NODE($$, STATEMENT_LIST, NULL, 2, $1, $2);
  };

print_list :
  print_item {
    MAKE_NODE($$, PRINT_LIST, NULL, 1, $1);
  }
| print_list ',' print_item {
    MAKE_NODE($$, PRINT_LIST, NULL, 2, $1, $3);
  };

expression_list :
  expression {
    MAKE_NODE($$, EXPRESSION_LIST, NULL, 1, $1);
  }
| expression_list ',' expression {
    MAKE_NODE($$, EXPRESSION_LIST, NULL, 2, $1, $3);
  };

variable_list :
  identifier {
    MAKE_NODE($$, VARIABLE_LIST, NULL, 1, $1);
  }
| variable_list ',' identifier {
    MAKE_NODE($$, VARIABLE_LIST, NULL, 2, $1, $3);
  };

argument_list :
  expression_list {
    MAKE_NODE($$, ARGUMENT_LIST, NULL, 1, $1);
  }
| {
    EMPTY_NODE($$,ARGUMENT_LIST, NULL);
  };

parameter_list :
  variable_list {
    MAKE_NODE($$, PARAMETER_LIST, NULL, 1, $1);
  }
| {
    EMPTY_NODE($$,PARAMETER_LIST, NULL);
  };

declaration_list :
  declaration {
    MAKE_NODE($$, DECLARATION_LIST, NULL, 1, $1);
  }
| declaration_list declaration {
    MAKE_NODE($$, DECLARATION_LIST, NULL, 2, $1, $2);
  };

function :
  FUNC identifier '(' parameter_list ')' statement {
    MAKE_NODE($$, FUNCTION, NULL, 3, $2, $4, $6);
  };

statement :
  assignment_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| return_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| print_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| if_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| while_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| null_statement {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  }
| block {
    MAKE_NODE($$, STATEMENT, NULL, 1, $1);
  };

block :
  OPENBLOCK declaration_list statement_list CLOSEBLOCK {
    MAKE_NODE($$, BLOCK, NULL, 2, $2, $3);
  }
| OPENBLOCK statement_list CLOSEBLOCK {
    MAKE_NODE($$, BLOCK, NULL, 1, $2);
  };

assignment_statement : 
  identifier ':' '=' expression {
    MAKE_NODE($$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $4);
  }
| identifier '+' '=' expression {
    MAKE_NODE($$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $4);
  }
| identifier '-' '=' expression {
    MAKE_NODE($$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $4);
  }
| identifier '*' '=' expression {
    MAKE_NODE($$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $4);
  }
| identifier '/' '=' expression {
    MAKE_NODE($$, ASSIGNMENT_STATEMENT, NULL, 2, $1, $4);
  };

return_statement :
  RETURN expression {
    MAKE_NODE($$, RETURN_STATEMENT, NULL, 1, $2);
  };

print_statement :
  PRINT print_list {
    MAKE_NODE($$, PRINT_STATEMENT, NULL, 1, $2);
  };

null_statement :
  CONTINUE {
    EMPTY_NODE($$,NULL_STATEMENT, NULL);
  };

if_statement :
  IF relation THEN statement {
    MAKE_NODE($$, IF_STATEMENT, NULL, 2, $2, $4);
  }
| IF relation THEN statement ELSE statement {
    MAKE_NODE($$, IF_STATEMENT, NULL, 3, $2, $4, $6);
  };

while_statement :
  WHILE relation DO statement {
    MAKE_NODE($$, WHILE_STATEMENT, NULL, 2, $2, $4);
  };

relation :
  expression '=' expression {
    MAKE_NODE($$, RELATION, NULL, 2, $1, $3);
  }
| expression '<' expression {
    MAKE_NODE($$, RELATION, NULL, 2, $1, $3);
  }
| expression '>' expression {
    MAKE_NODE($$, RELATION, NULL, 2, $1, $3);
  };

expression :
  expression '|' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '^' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '&' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '+' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '-' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '*' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| expression '/' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  }
| '-' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 1, $2);
  }
| '~' expression {
    MAKE_NODE($$, EXPRESSION, NULL, 1, $2);
  }
| '(' expression ')' {
    MAKE_NODE($$, EXPRESSION, NULL, 1, $2);
  }
| number {
    MAKE_NODE($$, EXPRESSION, NULL, 1, $1);
  }
| identifier {
    MAKE_NODE($$, EXPRESSION, NULL, 1, $1);
  }
| identifier '(' argument_list ')' {
    MAKE_NODE($$, EXPRESSION, NULL, 2, $1, $3);
  };

declaration :
  VAR variable_list {
    MAKE_NODE($$, DECLARATION, NULL, 1, $2);
  };

print_item :
  expression {
    MAKE_NODE($$, PRINT_ITEM, NULL, 1, $1);
  }
| string {
    MAKE_NODE($$, PRINT_ITEM, NULL, 1, $1);
  };

identifier :
  IDENTIFIER {
    EMPTY_NODE($$, IDENTIFIER_DATA, strdup(yytext));
  };

number :
  NUMBER {
    int64_t *val = malloc(sizeof(int64_t));
    *val = strtol(yytext, NULL, 10);
    EMPTY_NODE($$, NUMBER_DATA, val);
  };

string : 
  STRING {
    EMPTY_NODE($$, STRING_DATA, strdup(yytext));
  };
%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
