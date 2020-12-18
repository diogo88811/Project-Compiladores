//Diogo Valente Martins 2018297281   Miguel Pimenta 2018287956
#include "ast.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

node* create_node(const char* name){
	//printf("create node\n");
	node* n = (node *) malloc(sizeof(node));
	n->name = strdup(name);
	n->note = NULL;
	n->brother = NULL;
	n->son = NULL;
	return n;
}

node *create_node2(const char *str1, const char *str2){   
		//printf("create node2\n");
        char* arr = (char *) malloc(strlen(str1) + strlen(str2));
        sprintf(arr, str1, str2);
        return create_node(arr);
}

void add_next(node* n, node* n2){
	if (n == NULL || n2 == NULL){
		return;
	}
	node* temp = n;
	if (temp->brother == NULL){
		temp->brother = n2;
	} else {
		while (temp->brother != NULL){
			temp = temp->brother;
		}
		temp->brother = n2;
	}
}


void add_son(node* n, node* son){
	//printf("add son\n");
	if (n == NULL || son == NULL){
		return;
	}
	if (n->son == NULL){
		n->son = son;
	} else {
		add_next(n->son, son);
	}
}



void print_tree(int level, node* n){
	//printf("print tree\n");
	if (n == NULL) return;
	for (int i = 0; i < level; i++) printf("..");
	if(n->note == NULL){
		printf("%s\n", n->name);
	}
	else{
		printf("%s%s\n", n->name,n->note);
	}
	print_tree(level + 1, n->son);
	print_tree(level, n->brother);
}

void freeTree(node* n){
	//printf("free tree\n");
	if (n == NULL){
		return;
	}
	if (n->son != NULL){
		freeTree(n->son);
	}
	if (n->brother != NULL){
		freeTree(n->brother);
	}
	free(n->name);
	free(n);
}

