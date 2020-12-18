%{
//Diogo Valente Martins 2018297281   Miguel Pimenta 2018287956
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "y.tab.h"


int yylex(void);
void yyerror (char *s);
extern int numLines;
extern int numColumn;
extern char *yytext;
extern int yyleng;

struct node* tree;
struct node* node_aux;
char *type;

int erro = 0;
%}

%union{
    char *s;
    struct nodeInfo* noInfo;
    struct node* node;
};

%token <s> CHRLIT ID REALLIT INTLIT 
%type <s> TypeSpec
%type <node> Program  FunctionsAndDeclarations  FunctionDefinition FunctionBody DeclarationsAndStatements FunctionDeclaration FunctionDeclarator ParameterList ParameterList1 ParameterDeclaration Declaration COMMADEC  Declarator Statement StatementERROR StatementAUX Expr Expr1 

%type<noInfo> EQ

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
Program: 
        FunctionsAndDeclarations                               {tree = create_node("Program"); add_son(tree, $1); $$=tree;}
        ;

FunctionsAndDeclarations:
       FunctionDefinition                                      { $$ = $1 ;}
	|  FunctionDeclaration                                     { $$ = $1 ;}
	|  Declaration                                             { $$ = $1 ;}
    |  FunctionsAndDeclarations FunctionDefinition             { $$ = $1 ; add_next($$, $2); }
    |  FunctionsAndDeclarations  FunctionDeclaration           { $$ = $1 ; add_next($$, $2); } 
    |  FunctionsAndDeclarations Declaration                    { $$ = $1 ; add_next($$, $2); }
	;

FunctionDefinition:  
       TypeSpec FunctionDeclarator FunctionBody                { node_aux = create_node($1);$$ = create_node("FuncDefinition"); add_son($$,node_aux); add_son($$,$2), add_son($$,$3);}   
    ;

FunctionBody:                                               
       LBRACE DeclarationsAndStatements RBRACE                 { $$ = create_node("FuncBody"); if($2!=NULL)add_son($$,$2);}
    |  LBRACE RBRACE                                           { $$ = create_node("FuncBody");}
                ;
DeclarationsAndStatements:
            Statement DeclarationsAndStatements                     { if($1 != NULL){
                                                                    $$=$1;
                                                                    if($2 != NULL){
                                                                        add_next($$,$2);
                                                                    }
                                                                }
                                                                else{
                                                                   $$=$2;
                                                                };}

        |   Declaration DeclarationsAndStatements                 {if($1 != NULL){
                                                                    $$=$1;
                                                                    if($2 != NULL){
                                                                        add_next($$,$2);
                                                                    }
                                                                }
                                                                else{
                                                                   $$=$2;
                                                                };}

        | Statement                                             { $$ = $1 ;}

        | Declaration                                           { $$ = $1 ;}
        ;

FunctionDeclaration: 
        TypeSpec FunctionDeclarator SEMI                { node_aux = create_node($1); $$ = create_node("FuncDeclaration"); add_son($$,node_aux); add_next(node_aux,$2);}
        ;

FunctionDeclarator: 
        ID LPAR ParameterList RPAR                      { $$ = create_node2("Id(%s)", $1); add_next($$,$3);}
        ;

ParameterList:  
        ParameterDeclaration ParameterList1             { $$ = create_node("ParamList"); add_son($$,$1); add_next($1, $2);}
        ;

ParameterList1: 
        COMMA ParameterDeclaration ParameterList1       { $$ = $2   ; add_next($2, $3); }
        | /*empty*/                                     { $$ = NULL ;}
        ;

ParameterDeclaration:
          TypeSpec ID                                   { node_aux = create_node($1); $$ = create_node("ParamDeclaration"); add_son($$,node_aux); add_son($$,create_node2("Id(%s)",$2));}
        | TypeSpec                                      { node_aux = create_node($1);$$ = create_node("ParamDeclaration"); add_son($$,node_aux);}
        ;

Declaration: 
                                                
     TypeSpec Declarator SEMI                { node_aux = create_node($1); $$ = create_node("Declaration"); add_son($$, node_aux); add_son($$, $2);}
    |TypeSpec Declarator COMMADEC SEMI       { node_aux = create_node($1); $$ = create_node("Declaration"); add_son ($$, node_aux); add_son($$, $2); if($3 != NULL)add_next($$,$3);}
	|error SEMI		                         { $$ = create_node("Null") ;}
	    ;

COMMADEC: 
     COMMA Declarator                        { $$ = create_node("Declaration"); add_son($$,create_node(type)); add_son($$,$2);}
        
    |COMMA Declarator COMMADEC               { $$ = create_node("Declaration"); add_son($$,create_node(type)); add_son($$, $2); add_next($$, $3);}       
	;
    
TypeSpec:   
      CHAR                                              { $$ = type = "Char";}
    | INT                                               { $$ = type = "Int";}
    | VOID                                              { $$ = type = "Void";}
    | SHORT                                             { $$ = type = "Short";}
    | DOUBLE                                            { $$ = type = "Double";}
    ;

Declarator:

       ID ASSIGN Expr                                   { $$ = create_node2("Id(%s)", $1); add_next($$,$3);}
    |  ID                                               { $$ = create_node2("Id(%s)", $1);}
    ;

Statement:

        SEMI                                           { $$ = NULL ;}                                                                      
    |   Expr SEMI                                      { $$ = $1   ;}        
    |   LBRACE RBRACE                                  { $$ = NULL ;}
    |   LBRACE error RBRACE                            { $$ = create_node("Null");}

    |   LBRACE StatementAUX RBRACE                     {if($2 != NULL){
                                                            if($2->brother!=NULL){
                                                                $$ = create_node("StatList"); 
                                                                add_son($$,$2);
                                                            }
                                                            else
                                                                $$ = $2;
                                                        }else
                                                            $$ = $2;
                                                        
                                                        } 

    |   IF LPAR Expr RPAR StatementERROR                        {   $$ = create_node("If"); 
                                                                    if($3 != NULL){
                                                                        add_son($$,$3);
                                                                    }
                                                                    else{
                                                                        $3 = create_node("Null");
                                                                        add_son($$, $3);
                                                                    }
                                                                    if($5 != NULL){
                                                                        add_son($$,$5);
                                                                    }
                                                                    else{
                                                                        $5 = create_node("Null");
                                                                        add_son($$,$5);
                                                                    }
                                                                    add_son($$,create_node("Null"));
                                                                }

    |   IF LPAR Expr RPAR StatementERROR ELSE StatementERROR    {   $$ = create_node("If"); 
                                                                    if($3 != NULL){
                                                                        add_son($$,$3);
                                                                    }
                                                                    else{
                                                                        $3 = create_node("Null");
                                                                        add_son($$,$3);
                                                                    }
                                                                    if($5 != NULL){ 
                                                                        add_son($$,$5);
                                                                    }
                                                                    else{
                                                                        $5 = create_node("Null");
                                                                        add_son($$,$5);
                                                                    }
                                                                    if($7 != NULL){
                                                                        add_son($$,$7);
                                                                    }
                                                                    else{
                                                                        $7=create_node("Null");
                                                                        add_son($$,$7);
                                                                    }
                                                                } 

    |   WHILE LPAR Expr RPAR StatementERROR         { 
                                                        $$ = create_node("While");
                                                        if($3 != NULL){
                                                            add_son($$,$3);
                                                        }
                                                        else{
                                                            $3 = create_node("Null");
                                                            add_son($$,$3);
                                                        }
                                                        if($5 != NULL){ 
                                                            add_son($$,$5);
                                                        }
                                                        else{
                                                            $5 = create_node("Null");
                                                            add_son($$,$5);
                                                        }
                                                    }

    |   RETURN SEMI                                 { $$ = create_node("Return"); add_son($$, create_node("Null"));}

    |   RETURN Expr SEMI                            { $$ = create_node("Return"); add_son($$, $2);}
    ;      

StatementAUX:

        StatementERROR StatementAUX                 {if($1!=NULL){
                                                        $$ = $1;
                                                        if($2 != NULL)
                                                            add_next($1,$2);
                                                        }else
                                                            $$ = $2;
                                                    }
                 
    |   StatementERROR                              { $$ = $1 ;}   
    ;

StatementERROR:    

        Statement                                   { $$ = $1 ;} 

    |   error SEMI                                  { $$= create_node("Null");}                     
    ;  

Expr:
       Expr ASSIGN  Expr                            { $$ = create_node("Store"); add_son($$, $1); add_next($1, $3);}
    |  Expr COMMA Expr                              { $$ = create_node("Comma"); add_son($$, $1); add_next($1, $3);}
    |  Expr PLUS Expr                               { $$ = create_node("Add"); add_son($$, $1); add_next($1, $3);}
    |  Expr MINUS Expr                              { $$ = create_node("Sub"); add_son($$, $1); add_next($1, $3);}
    |  Expr MUL Expr                                { $$ = create_node("Mul"); add_son($$, $1); add_next($1, $3);}
    |  Expr DIV Expr                                { $$ = create_node("Div"); add_son($$, $1); add_next($1, $3);}
    |  Expr MOD Expr                                { $$ = create_node("Mod"); add_son($$, $1); add_next($1, $3);}
    |  Expr OR Expr                                 { $$ = create_node("Or"); add_son($$, $1); add_next($1, $3);}
    |  Expr AND Expr                                { $$ = create_node("And"); add_son($$, $1); add_next($1, $3);}
    |  Expr BITWISEAND Expr                         { $$ = create_node("BitWiseAnd"); add_son($$, $1); add_next($1, $3);}
    |  Expr BITWISEOR Expr                          { $$ = create_node("BitWiseOr"); add_son($$, $1); add_next($1, $3);}
    |  Expr BITWISEXOR Expr                         { $$ = create_node("BitWiseXor"); add_son($$, $1); add_next($1, $3);}
    |  Expr EQ Expr                                 { $$ = create_node("Eq"); add_son($$, $1); add_next($1, $3);printf("%d\n",$2->line);}
    |  Expr NE Expr                                 { $$ = create_node("Ne"); add_son($$, $1); add_next($1, $3);}
    |  Expr LE Expr                                 { $$ = create_node("Le"); add_son($$, $1); add_next($1, $3);}
    |  Expr GE Expr                                 { $$ = create_node("Ge"); add_son($$, $1); add_next($1, $3);}
    |  Expr LT Expr                                 { $$ = create_node("Lt"); add_son($$, $1); add_next($1, $3);}
    |  Expr GT Expr                                 { $$ = create_node("Gt"); add_son($$, $1); add_next($1, $3);}
    |  PLUS Expr %prec DIV                          { $$ = create_node("Plus"); add_son($$, $2);}
    |  MINUS Expr %prec DIV                         { $$ = create_node("Minus"); add_son($$, $2);}
    |  NOT Expr                                     { $$ = create_node("Not"); add_son($$, $2);}


    |  ID LPAR Expr Expr1 RPAR                      { $$ = create_node("Call");
                                                      add_son($$, create_node2("Id(%s)", $1));
                                                      add_son($$,$3);
                                                      if($4!=NULL)
                                                        add_son($$,$4);
                                                    ;}

    |  ID LPAR error RPAR	                        { $$ = create_node("Null");}
	|  ID LPAR RPAR	                                { $$ = create_node("Call"); add_son($$,create_node2("Id(%s)", $1));}
	|  LPAR Expr RPAR	                            { $$ = $2;} 
	|  LPAR error RPAR	                            { $$ = create_node("Null");}
	|  REALLIT                                      { $$ = create_node2("RealLit(%s)", $1);}   
	|  INTLIT                                       { $$ = create_node2("IntLit(%s)", $1);}
	|  ID                                           { $$ = create_node2("Id(%s)", $1);}
	|  CHRLIT                                       { $$ = create_node2("ChrLit(%s)", $1);}
	;
    
Expr1:	
      Expr1 COMMA Expr                               {if($1 != NULL){ 
                                                        $$ = $1; 
                                                    
                                                        if($3 != NULL){
                                                            add_next($$,$3);
                                                        }
                                                    }
                                                    else{ $$ = $3;

                                                    }}
	| %prec COMMA                                    { $$ = NULL ;}
	;
%%

void yyerror(char *s) {
    erro = 1;
    if(yychar == 0){
       printf("Line %d, col %d: %s: %s\n",numLines,numColumn, s ,yytext); 
    }
    else{
       printf("Line %d, col %d: %s: %s\n",numLines,numColumn - yyleng, s ,yytext); 
    }
}
