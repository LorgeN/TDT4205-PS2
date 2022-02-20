%{
#include <vslc.h>
%}
%option noyywrap
%option array
%option yylineno

WHITESPACE [\ \t\v\r\n]
COMMENT \/\/[^\n]+
NUMBER [0-9]+
STRING \".*\"
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
%%
func                    { return FUNC; }
begin { return OPENBLOCK; }
end { return CLOSEBLOCK; }
return { return RETURN; }
print { return PRINT; }
continue { return CONTINUE; }
if { return IF; }
then { return THEN; }
else { return ELSE; }
while { return WHILE; }
do { return DO; }
var { return VAR; }
{STRING}                { return STRING; }
{IDENTIFIER}            { return IDENTIFIER; }
{NUMBER}                { return NUMBER; }
{WHITESPACE}+           { /* Eliminate whitespace */ }
{COMMENT}               { /* Eliminate comments */ }
.                       { return yytext[0]; }
%%
