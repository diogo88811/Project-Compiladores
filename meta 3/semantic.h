#include "ast.h"

int check_program(node *self);
char *TypeOfData(char *type);
char * paraFunction(node *self);
void insert_parameters(node *node);
void bottomTopTree(node *node, char *tableName);
void recursive(node* node, char *tableName);
void verifyEntryParameters(node* node,char* type);
void changeTreeReturn(node* node);
int check_tree(node *no);

