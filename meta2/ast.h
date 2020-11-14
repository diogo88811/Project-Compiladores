#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct node{
	char *name;
	struct node* son;
	struct node* brother;
} node;

node* create_node(const char* name);
node *create_node2(const char *str_tipo, const char *str);       
void add_next(node* n, node* n2);
void add_son(node* n, node* son);
void print_tree(int level, node* n);
void freeTree(node* n);