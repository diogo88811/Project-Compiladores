%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror (char *s);

extern int numLines;
extern int numColumn;
extern char *yytext;
extern int yyleng;


%}

%union{
	char charval;
	long intval;
	char* strval;
    char *s;
};

%token <charval> CHRLIT
%token <strval> ID REALLIT
%token <intval> INTLIT

%left COMMA
%right ASSIGN
%left OR
%left XOR
%left AND
%left BITWISEOR
%left BITWISEXOR
%left BITWISEAND
%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left MUL DIV MOD
%right NOT
%left LPAR RPAR
%nonassoc ELSE


%token CHAR 
%token ELSE         
%token WHILE       
%token INT         
%token IF           
%token SHORT        
%token DOUBLE      
%token RETURN     
%token VOID         
%token BITWISEAND  
%token BITWISEOR  
%token BITWISEXOR   
%token AND         
%token ASSIGN      
%token MUL         
%token COMMA       
%token DIV         
%token EQ          
%token GE          
%token GT          
%token LBRACE      
%token LE          
%token LPAR        
%token LT          
%token MINUS       
%token MOD         
%token NE          
%token NOT         
%token OR          
%token PLUS        
%token RBRACE      
%token RPAR        
%token SEMI
%token RESERVED      



%%
Programa: FunctionsAndDeclarations
	    ;

FunctionsAndDeclarations:
                       FunctionsAndDeclarations_list FunctionDefinition 
	|              FunctionsAndDeclarations_list FunctionDeclaration 
	|           FunctionsAndDeclarations_list    Declaration 
	;
FunctionsAndDeclarations_list:	FunctionsAndDeclarations_list FunctionDefinition 
	|			FunctionsAndDeclarations_list FunctionDeclaration 
	|			FunctionsAndDeclarations_list Declaration 
	|							/* empty */ 
	;

FunctionDefinition:  
                TypeSpec FunctionDeclarator FunctionBody
                ;


FunctionBody: 
                LBRACE DeclarationsAndStatements RBRACE
                |LBRACE RBRACE
                ;
DeclarationsAndStatements:
                         DeclarationsAndStatements Statement  
                        | DeclarationsAndStatements Declaration  
                        | Statement 
                        | Declaration
                        ;
FunctionDeclaration: 
                    TypeSpec FunctionDeclarator SEMI
                    ;
FunctionDeclarator: 
                ID LPAR ParameterList RPAR
                ;
ParameterList:  
                ParameterDeclaration ParameterList1
                ;
ParameterList1: 
                COMMA ParameterDeclaration ParameterList1
                | /*empty*/
                ;
ParameterDeclaration:
                    TypeSpec ID
                    |TypeSpec
                    ;

Declaration: TypeSpec Declarator COMMADEC SEMI
	|		 error SEMI		
	;
COMMADEC: COMMADEC COMMA Declarator 
	|			 /* empty */
	;
TypeSpec:   
            CHAR 
            | INT 
            | VOID 
            | SHORT 
            | DOUBLE
            ;
Declarator:
             ID ASSIGN Expr
             |ID
             ;
Statement:
        SEMI                                                                                        
    |   Expr SEMI                                   
    |   LBRACE RBRACE                               
    |   LBRACE error RBRACE                         
    |   LBRACE StatementAUX RBRACE                  
    |   IF LPAR Expr RPAR StatementERROR         
    |   IF LPAR Expr RPAR StatementERROR ELSE StatementERROR    
    |   WHILE LPAR Expr RPAR StatementERROR         
    |   RETURN SEMI                                 
    |   RETURN Expr SEMI                            
    ;

StatementERROR:     
        Statement                                   
    |   error SEMI                                  
    ;        

StatementAUX:
        StatementERROR StatementAUX                     
    |   StatementERROR                              
    ;

Expr:
      Expr ASSIGN  Expr
    | Expr COMMA Expr 
    | Expr PLUS Expr
    | Expr MINUS Expr 
    | Expr MUL Expr 
    | Expr DIV Expr 
    | Expr MOD Expr

     | Expr OR Expr
     | Expr AND Expr 
     | Expr BITWISEAND Expr 
     | Expr BITWISEOR Expr 
     | Expr BITWISEXOR Expr
 
    | Expr EQ Expr 
    | Expr NE Expr 
    | Expr LE Expr 
    | Expr GE Expr
    | Expr LT Expr 
    | Expr GT Expr

    | PLUS Expr 
    | MINUS Expr 
    | NOT Expr

        |	ID LPAR Expr Expr1
        |	ID LPAR error RPAR	/* for syntax error */
	|	ID LPAR RPAR				
	|	LPAR Expr RPAR	
	|	LPAR error RPAR	/* for syntax error */
	|	REALLIT
	|	INTLIT
	|	ID
	|	CHRLIT
	;
    ;
Expr1:	COMMA Expr Expr1
	|RPAR
	;
%%

void yyerror(char *s) {
    if(yychar == 0){
       printf("Line %d, col %d: %s: %s\n",numLines,numColumn, s ,yytext); 
    }
    else{
       printf("Line %d, col %d: %s: %s\n",numLines,numColumn - yyleng, s ,yytext); 
    }
}
