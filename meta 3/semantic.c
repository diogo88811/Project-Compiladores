#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic.h"
#include "symbol_tabel.h"

char name[30];
int check_program(node *no)
{
	if (no == NULL)
		return 0;

	if (no->name != NULL)
	{
		if (strcmp(no->name, "Program") == 0)
		{
			strcpy(name, "Global");
			insert_data("putchar", "int(int)", "", "Global");
			insert_data("getchar", "int(void)", "", "Global");
		}

		if (strcmp(no->name, "FuncDefinition") == 0)
		{
			char *type = TypeOfData(no->son->name);
			strcpy(name, no->son->brother->name);
			char *param = paraFunction(no->son->brother->brother->son);
			if(param != NULL){
				insert_data(no->son->brother->name, type, param, "Global");
				insert_data_functtable("return", type, "", name);

				insert_parameters(no->son->brother->brother->son);
			}
			
			//bottomTopTree(no, name);
		}

		if (strcmp(no->name, "FuncDeclaration") == 0)
		{
			char *type = TypeOfData(no->son->name);
			char *param = paraFunction(no->son->brother->brother->son);
			if(param != NULL)
				insert_data(no->son->brother->name, type, param, "Global");
			
			//bottomTopTree(no, name);
		}

		if (strcmp(no->name, "Declaration") == 0)
		{
			char *type = TypeOfData(no->son->name);
			if (strcmp(name, "Global") == 0 && strcmp(type, "void") != 0)
			{
				insert_data(no->son->brother->name, type, "", name);
			}
			if (strcmp(name, "Global") != 0 && strcmp(type, "void") != 0)
			{
				insert_data_functtable(no->son->brother->name, type, "", name);
			}
			//bottomTopTree(no, name);
		}
	}
	node *auxNo = no->son;

	while (auxNo != NULL)
	{
		if (no->name != NULL && strcmp(no->name, "Program") == 0)
			strcpy(name, "Global");
		check_program(auxNo);
		auxNo = auxNo->brother;
	}
	return 0;
}

char *TypeOfData(char *type)
{ //type of data
	char *t = NULL;
	if (strcmp(type, "Char") == 0)
	{
		t = (char *)"char";
		return t;
	}
	else if (strcmp(type, "Int") == 0)
	{
		t = (char *)"int";
		return t;
	}
	else if (strcmp(type, "Void") == 0)
	{
		t = (char *)"void";
		return t;
	}
	else if (strcmp(type, "Short") == 0)
	{
		t = (char *)"short";
		return t;
	}
	else if (strcmp(type, "Double") == 0)
	{
		t = (char *)"double";
		return t;
	}
	return NULL;
}

char *paraFunction(node *no)
{ //main(void, int)
	char param[100] = "(";
	node *aux = no;

	if (strcmp(aux->son->name, "Void") == 0 && aux->brother != NULL)
	{
		return NULL;
	}
	else if (strcmp(aux->son->name, "Void") == 0 && aux->brother == NULL)
	{
		char *types = TypeOfData(aux->son->name);
		strcat(param, types);
		strcat(param, ")");

		return strdup(param);
	}

	while (aux != NULL)
	{
		char *types = TypeOfData(aux->son->name);
		if (strcmp(types, "void") == 0)
		{
			return NULL;
		}
		strcat(param, types);
		aux = aux->brother;
		if (aux != NULL)
			strcat(param, ",");
	}
	strcat(param, ")");

	return strdup(param);
}
void insert_parameters(node *node){

		while(node != NULL){
			if(node->son != NULL){
				char * typeParam = TypeOfData(node->son->name);
				if(node->son->brother != NULL){
					insert_data_functtable(node->son->brother->name,typeParam,"\tparam",name);
				}
			}
			node = node->brother;
		}
	}

int check_tree(node *no)
{
	if (no == NULL)
		return 0;

	if (no->name != NULL)
	{
		
		if (strcmp(no->name, "FuncDefinition") == 0)
		{
			strcpy(name, no->son->brother->name);
			
			bottomTopTree(no, name);
		}

		if (strcmp(no->name, "FuncDeclaration") == 0)
		{
			
			bottomTopTree(no, name);
		}

		if (strcmp(no->name, "Declaration") == 0)
		{
			bottomTopTree(no, name);
		}
	}
	node *auxNo = no->son;

	while (auxNo != NULL)
	{
		if (no->name != NULL && strcmp(no->name, "Program") == 0)
			strcpy(name, "Global");
		check_tree(auxNo);
		auxNo = auxNo->brother;
	}
	return 0;
}
void bottomTopTree(node *node, char *tableName){
	char *token;
	char auxName[20];

	if(node->son != NULL){
		node = node->son;
		while(node->brother != NULL){
			node = node->brother;
		}
	}
	strcpy(auxName, node->name);
	token = strtok(auxName, "(");
	if(strcmp(token, "Id")==0){
		return;
	}
	else{
		recursive(node, tableName);	
	}
}

void recursive(node* node, char *tableName){

	char *token;
	char *token2;
	char auxName[20];
	char funcName[30];
	
	if(node == NULL){
		return;
	}

	strcpy(funcName, node->name);
	token2 = strtok(funcName, "(");
	if(strcmp(token2, "Id")== 0){
		char* types = find_table(node->name, tableName);
		if(strcmp(types, "") == 0){
			node->note = (char *) strdup(" - undef");
		}
		else{
			char *aux = (char *) malloc(sizeof(char) * (4 + strlen(types)));
			aux[0]='\0';
			strcat(aux, " - ");
			strcat(aux, types);
			node->note = (char *) strdup(aux);
		}
	}
		
	if(strcmp(node->name, "Or") == 0 || strcmp(node->name, "And") == 0 || strcmp(node->name, "BitWiseAnd") == 0 || strcmp(node->name, "BitWiseXor") == 0 || strcmp(node->name, "BitWiseOr") == 0 || strcmp(node->name, "Mod") == 0){
		recursive(node->son, tableName);
		node->note = (char *) strdup(" - int");
	}

	if(strcmp(node->name, "Not") == 0 || strcmp(node->name, "Eq") == 0 || strcmp(node->name, "Ne") == 0 || strcmp(node->name, "Le") == 0 || strcmp(node->name, "Ge") == 0 || strcmp(node->name, "Lt") == 0 || strcmp(node->name, "Gt") == 0){
		recursive(node->son, tableName);
		node->note = (char *) strdup(" - int");
	}

	strcpy(auxName, node->name);
	token = strtok(auxName, "(");
	if(strcmp(token, "IntLit") == 0 || strcmp(token, "ChrLit")== 0){
		node->note = (char *) strdup(" - int");
	}

	if(strcmp(token,"RealLit") ==0 ){
		node->note = (char *) strdup(" - double");
	}

	if(strcmp(node->name, "Comma")== 0 ){
		recursive(node->son, tableName);
		node->note = (char *) strdup(node->son->brother->note);
	}

	if(strcmp(node->name, "Sub")==0 || strcmp(node->name, "Mul")==0 || strcmp(node->name, "Add")==0 || strcmp(node->name, "Div")==0 ){
		recursive(node->son, tableName);

		if(strcmp(node->son->note, " - undef")==0 || strcmp(node->son->brother->note, " - undef")==0){
			node->note = (char *) strdup(" - undef");
		}

		else if(strcmp(node->son->note, " - double")==0 || strcmp(node->son->brother->note, " - double")==0){
			node->note = (char *) strdup(" - double");
		}
		
		else if(strcmp(node->son->note, " - int")==0 || strcmp(node->son->brother->note, " - int")==0){
			node->note = (char *) strdup(" - int");
		}

		else if(strcmp(node->son->note, " - short")==0 || strcmp(node->son->brother->note, " - short")==0){
			node->note = (char *) strdup(" - short");
		}
		
		else if(strcmp(node->son->note, " - char")==0 || strcmp(node->son->brother->note, " - char")==0){
			node->note = (char *) strdup(" - char");
		}
		
	}

	if(strcmp(node->name, "Minus")==0 || strcmp(node->name, "Plus")==0 ){
		recursive(node->son, tableName);
		if(node->son != NULL){
			node->note = (char *) strdup(node->son->note);
		}
	}

	if(strcmp(node->name, "Store")== 0 ){
		recursive(node->son, tableName);
		if(node->son != NULL){
			node->note = (char *) strdup(node->son->note);
		}
	}

	if(strcmp(node->name, "Call")== 0 ){
		char auxName[20];
		recursive(node->son, tableName);
		if(node->son != NULL){
			strcpy(auxName, node->son->note);
			token = strtok(auxName, "(");
			node->note = (char *) strdup(auxName);
		}
	}

	if(strcmp(node->name, "While")== 0 || strcmp(node->name, "If")== 0 ){
		recursive(node->son, tableName);
		/*if(strcmp(node->son->note, " - double")==0 || strcmp(node->son->note, " - undef")==0){
			printf("ERRO\n");
		}*/
	}

	if(strcmp(node->name, "StatList")== 0 || strcmp(node->name, "FuncBody")== 0 ){
		recursive(node->son, tableName);
	}

	if(strcmp(node->name, "Return")== 0 ){
		recursive(node->son, tableName);
	}

	recursive(node->brother, tableName);
}

