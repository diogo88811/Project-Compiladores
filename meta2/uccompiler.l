/*Diogo Valente Martins 2018297281   Miguel Pimenta 2018287956*/
%{
    #include <stdbool.h>
    #include <string.h>
    #include "y.tab.h"
    #include "ast.h"
    int numLines = 1;
    int numColumn = 1;
    int startColumn = 1;

    int errCol = 1;
    int errLine = 1;
    bool print = false;
    extern node* tree;
    extern int erro;
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
BITWISEAND  "&"
BITWISEOR  "|"
BITWISEXOR   "^"
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


{CHAR}                  {if (print)printf("CHAR\n")         ; startColumn = numColumn; numColumn += yyleng;return CHAR;}
{ELSE}                  {if(print)printf("ELSE\n")          ;startColumn = numColumn; numColumn += yyleng;return ELSE;}
{WHILE}                 {if(print)printf("WHILE\n")         ;startColumn = numColumn; numColumn += yyleng;return WHILE;}
{IF}                    {if(print)printf("IF\n")            ;startColumn = numColumn; numColumn += yyleng;return IF;}
{INT}                   {if(print)printf("INT\n")           ;startColumn = numColumn; numColumn += yyleng;return INT;}
{SHORT}                 {if(print)printf("SHORT\n")         ;startColumn = numColumn; numColumn += yyleng;return SHORT;}
{DOUBLE}                {if(print)printf("DOUBLE\n")         ;startColumn = numColumn; numColumn += yyleng;return DOUBLE;} 
{RETURN}                {if(print)printf("RETURN\n")           ;startColumn = numColumn; numColumn += yyleng;return RETURN;}
{VOID}                  {if(print)printf("VOID\n");startColumn = numColumn; numColumn += yyleng;return VOID;}
{BITWISEAND}           {if(print)printf("BITWISEAND\n");startColumn = numColumn; numColumn += yyleng;return BITWISEAND;}
{BITWISEOR}            {if(print)printf("BITWISEOR\n");startColumn = numColumn; numColumn += yyleng;return BITWISEOR;}
{BITWISEXOR}           {if(print)printf("BITWISEXOR\n");startColumn = numColumn; numColumn += yyleng;return BITWISEXOR;}
{AND}                   {if(print)printf("AND\n");startColumn = numColumn; numColumn += yyleng;return AND;}
{ASSIGN}                {if(print)printf("ASSIGN\n");startColumn = numColumn; numColumn += yyleng;return ASSIGN;}
{MUL}                   {if(print)printf("MUL\n");startColumn = numColumn; numColumn += yyleng;return MUL;}
{COMMA}                 {if(print)printf("COMMA\n");startColumn = numColumn; numColumn += yyleng;return COMMA;}
{DIV}                   {if(print)printf("DIV\n");startColumn = numColumn; numColumn += yyleng;return DIV;}
{SEMI}                  {if(print)printf("SEMI\n");startColumn = numColumn; numColumn += yyleng;return SEMI;}
{RPAR}                  {if(print)printf("RPAR\n");startColumn = numColumn; numColumn += yyleng;return RPAR;}
{RBRACE}                {if(print)printf("RBRACE\n");startColumn = numColumn; numColumn += yyleng;return RBRACE;}
{PLUS}                  {if(print)printf("PLUS\n");startColumn = numColumn; numColumn += yyleng;return PLUS;}
{OR}                    {if(print)printf("OR\n");startColumn = numColumn; numColumn += yyleng;return OR;}
{NOT}                   {if(print)printf("NOT\n");startColumn = numColumn; numColumn += yyleng;return NOT;}
{NE}                    {if(print)printf("NE\n");startColumn = numColumn; numColumn += yyleng;return NE;}
{MOD}                   {if(print)printf("MOD\n");startColumn = numColumn; numColumn += yyleng;return MOD;}
{MINUS}                 {if(print)printf("MINUS\n");startColumn = numColumn; numColumn += yyleng;return MINUS;}
{LT}                    {if(print)printf("LT\n");startColumn = numColumn; numColumn += yyleng;return LT;}
{LPAR}                  {if(print)printf("LPAR\n");startColumn = numColumn; numColumn += yyleng;return LPAR;}
{LE}                    {if(print)printf("LE\n");startColumn = numColumn; numColumn += yyleng;return LE;}
{LBRACE}                {if(print)printf("LBRACE\n");startColumn = numColumn; numColumn += yyleng;return LBRACE;}
{GT}                    {if(print)printf("GT\n");startColumn = numColumn; numColumn += yyleng;return GT;}
{GE}                    {if(print)printf("GE\n");startColumn = numColumn; numColumn += yyleng;return GE;}
{EQ}                    {if(print)printf("EQ\n");startColumn = numColumn; numColumn += yyleng;return EQ;}

{RESERVED}              {if(print)printf("RESERVED(%s)\n",yytext);numColumn += yyleng;startColumn = numColumn;yylval.s = strdup(yytext);return RESERVED; }

{ID}                    {if(print)printf("ID(%s)\n",yytext);numColumn += yyleng;startColumn = numColumn;yylval.s = strdup(yytext);return ID; }

{CHRLIT}                {if(print)printf("CHRLIT(%s)\n",yytext);numColumn +=yyleng; startColumn = numColumn;BEGIN 0;yylval.s = strdup(yytext);return CHRLIT; }

{INVALIDCHAR}           {printf("Line %d, col %d: invalid char constant (%s)\n", numLines, numColumn, yytext);numColumn +=yyleng; startColumn = numColumn;}

{UNTERMINATEDCHAR}      {printf("Line %d, col %d: unterminated char constant\n", numLines, numColumn);numColumn +=yyleng; startColumn = numColumn;
                         if (strcmp(&yytext[strlen(yytext)-1],"\n") == 0){numLines++;numColumn = 1;} }

{INTLIT}                {if(print)printf("INTLIT(%s)\n",yytext); numColumn += yyleng;startColumn = numColumn;yylval.s = strdup(yytext); return INTLIT;}

{REALLIT}               {if(print)printf("REALLIT(%s)\n",yytext);startColumn = numColumn; numColumn += yyleng;yylval.s = strdup(yytext); return REALLIT;}

{NEWLINE}               {; numLines++; numColumn = 1;}


{WHITESPACE}            {; numColumn += yyleng; startColumn = numColumn;}


.                       {printf("Line %d, col %d: illegal character (%s)\n", numLines, numColumn, yytext);numColumn+=yyleng; }


%%


int main(int argc, char *argv[])
{
	if (argc==1 || strcmp(argv[1],"-e2")==0)
    {
        print = false;
		yyparse();
        if(tree != NULL){
            free_tree(tree);
        }
        
    }
    else if(strcmp(argv[1],"-e1")==0){
        print = false;
		yylex();
    }
    else if(strcmp(argv[1],"-l")==0){
        print = true;
		yylex();
    }
    else if(strcmp(argv[1],"-t")==0){
        yyparse();
        if(erro==0){
            print_tree(0,tree);
        }
        if(tree != NULL){
            free_tree(tree);
        }
    }
    
	return 0;
}

int yywrap()
{
    return 1;
}