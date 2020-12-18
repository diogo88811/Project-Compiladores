/*Diogo Valente Martins 2018297281   Miguel Pimenta 2018287956*/
%{
    #include <stdbool.h>
    #include <string.h>
    #include "y.tab.h"
    int numLines = 1;
    int numColumn = 1;
    int startColumn = 1;

    int errCol = 1;
    int errLine = 1;
    bool print = false;
%}

ID                  [a-zA-Z\_][a-zA-Z\_0-9]*
INTLIT              [0-9]+
CHRLIT              \'([^\n\'\\]|\\n|\\t|\\\\|\\\'|\\\"|(\\[0-7][0-7]?[0-7]?))\'
NUMBER              [0-9]|[0-9][0-9"_"]*[0-9]
EXPOENT             ["e""E"]("-"|"+")?{NUMBER}
REALLIT             {NUMBER}"."{NUMBER}?{EXPOENT}?|"."{NUMBER}{EXPOENT}?|{NUMBER}{EXPOENT}
RESERVED            "do"|"long"|"register"|"return"|"signed"|"sizeof"|"_Imaginary"|"_Complex"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"enum"|"extern"|"_Bool"|"float"|"for"|"goto"|"["|"]"|"++"|"--"|"auto"|"break"|"case"|"const"|"continue"|"restrict"|"inline"|"default"
NEWLINE             \r\n|\r|\n
WHITESPACE          " "|"\t"|"\f"
INVALIDCHAR         \'([^\n\'\\]|\\.)*\'

UNTERMINATEDCHAR    \'([^\n\'\\]|\\.)*(\\)?

%X COMENT
%X COMENT1

CHAR        "char"
ELSE        "else" 
WHILE       "while" 
INT         "int"
IF          "if" 
SHORT       "short" 
DOUBLE      "double" 
RETURN      "return"
VOID        "void" 
BITEWISEAND  "&"
BITEWISEOR  "|"
BITEWISEXOR   "^"
AND         "&&"
ASSIGN      "="
MUL         "*"
COMMA       ","
DIV         "/"
EQ          "=="
GE          ">="
GT          ">"
LBRACE      "{"
LE          "<="
LPAR        "("
LT          "<"
MINUS       "-"
MOD         "%"
NE          "!="
NOT         "!"
OR          "||"
PLUS        "+"
RBRACE      "}"
RPAR        ")"
SEMI        ";"

%%

"//"                   {BEGIN COMENT; numColumn += yyleng; startColumn = numColumn; }
<COMENT>{NEWLINE}       {BEGIN 0; numLines++;numColumn = 1; startColumn = numColumn; }
<COMENT>.               {numColumn += yyleng; startColumn = numColumn; }

"/*"                   {BEGIN COMENT1; errLine = numLines; errCol = numColumn; numColumn += yyleng; startColumn = numColumn;}
<COMENT1>{NEWLINE}      { numLines++;  numColumn = 1; startColumn = numColumn; }
<COMENT1>.              {numColumn += yyleng; startColumn = numColumn;}
<COMENT1>"*/"           {BEGIN 0; numColumn += yyleng; startColumn = numColumn; }
<COMENT1><<EOF>>        {printf("Line %d, col %d: unterminated comment\n",errLine, errCol ); BEGIN 0;}


{CHAR}                  {if (print)printf("CHAR\n")         ; startColumn = numColumn; numColumn += yyleng;}
{ELSE}                  {if(print)printf("ELSE\n")          ;startColumn = numColumn; numColumn += yyleng;}
{WHILE}                 {if(print)printf("WHILE\n")         ;startColumn = numColumn; numColumn += yyleng;}
{IF}                    {if(print)printf("IF\n")            ;startColumn = numColumn; numColumn += yyleng;}
{INT}                   {if(print)printf("INT\n")           ;startColumn = numColumn; numColumn += yyleng;}
{SHORT}                 {if(print)printf("SHORT\n")         ;startColumn = numColumn; numColumn += yyleng;}
{DOUBLE}                {if(print)printf("DOUBLE\n")         ;startColumn = numColumn; numColumn += yyleng;} 
{RETURN}                {if(print)printf("RETURN\n")           ;startColumn = numColumn; numColumn += yyleng;}
{VOID}                  {if(print)printf("VOID\n");startColumn = numColumn; numColumn += yyleng;}
{BITEWISEAND}           {if(print)printf("BITWISEAND\n");startColumn = numColumn; numColumn += yyleng;}
{BITEWISEOR}            {if(print)printf("BITWISEOR\n");startColumn = numColumn; numColumn += yyleng;}
{BITEWISEXOR}           {if(print)printf("BITWISEXOR\n");startColumn = numColumn; numColumn += yyleng;}
{AND}                   {if(print)printf("AND\n");startColumn = numColumn; numColumn += yyleng;}
{ASSIGN}                {if(print)printf("ASSIGN\n");startColumn = numColumn; numColumn += yyleng;}
{MUL}                   {if(print)printf("MUL\n");startColumn = numColumn; numColumn += yyleng;}
{COMMA}                 {if(print)printf("COMMA\n");startColumn = numColumn; numColumn += yyleng;}
{DIV}                   {if(print)printf("DIV\n");startColumn = numColumn; numColumn += yyleng;}
{SEMI}                  {if(print)printf("SEMI\n");startColumn = numColumn; numColumn += yyleng;}
{RPAR}                  {if(print)printf("RPAR\n");startColumn = numColumn; numColumn += yyleng;}
{RBRACE}                {if(print)printf("RBRACE\n");startColumn = numColumn; numColumn += yyleng;}
{PLUS}                  {if(print)printf("PLUS\n");startColumn = numColumn; numColumn += yyleng;}
{OR}                    {if(print)printf("OR\n");startColumn = numColumn; numColumn += yyleng;}
{NOT}                   {if(print)printf("NOT\n");startColumn = numColumn; numColumn += yyleng;}
{NE}                    {if(print)printf("NE\n");startColumn = numColumn; numColumn += yyleng;}
{MOD}                   {if(print)printf("MOD\n");startColumn = numColumn; numColumn += yyleng;}
{MINUS}                 {if(print)printf("MINUS\n");startColumn = numColumn; numColumn += yyleng;}
{LT}                    {if(print)printf("LT\n");startColumn = numColumn; numColumn += yyleng;}
{LPAR}                  {if(print)printf("LPAR\n");startColumn = numColumn; numColumn += yyleng;}
{LE}                    {if(print)printf("LE\n");startColumn = numColumn; numColumn += yyleng;}
{LBRACE}                {if(print)printf("LBRACE\n");startColumn = numColumn; numColumn += yyleng;}
{GT}                    {if(print)printf("GT\n");startColumn = numColumn; numColumn += yyleng;}
{GE}                    {if(print)printf("GE\n");startColumn = numColumn; numColumn += yyleng;}
{EQ}                    {if(print)printf("EQ\n");startColumn = numColumn; numColumn += yyleng;}

{RESERVED}              {if(print)printf("RESERVED(%s)\n",yytext);numColumn += yyleng;startColumn = numColumn; }

{ID}                    {if(print)printf("ID(%s)\n",yytext);numColumn += yyleng;startColumn = numColumn; }

{CHRLIT}                {if(print)printf("CHRLIT(%s)\n",yytext);numColumn +=yyleng; startColumn = numColumn;BEGIN 0; }

{INVALIDCHAR}           {printf("Line %d, col %d: invalid char constant (%s)\n", numLines, numColumn, yytext);numColumn +=yyleng; startColumn = numColumn;}

{UNTERMINATEDCHAR}      {printf("Line %d, col %d: unterminated char constant\n", numLines, numColumn);numColumn +=yyleng; startColumn = numColumn;
                         if (strcmp(&yytext[strlen(yytext)-1],"\n") == 0){numLines++;numColumn = 1;} }

{INTLIT}                {if(print)printf("INTLIT(%s)\n",yytext); numColumn += yyleng;startColumn = numColumn;}

{REALLIT}               {if(print)printf("REALLIT(%s)\n",yytext);startColumn = numColumn; numColumn += yyleng;}

{NEWLINE}               {; numLines++; numColumn = 1;}


{WHITESPACE}            {; numColumn += yyleng; startColumn = numColumn;}


.                       {printf("Line %d, col %d: illegal character (%s)\n", numLines, numColumn, yytext);numColumn+=yyleng; }


%%
int main(int argc, char *argv[])
{
    if(argc == 2){
        if(strcmp(argv[1], "-l") == 0){
            //imprimir tudo
            print = true;
        }
    }
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}