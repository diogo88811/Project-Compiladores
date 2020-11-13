//Diogo Valente Martins 2018297281   Miguel Pimenta 2018287956
#include "ast.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

node* create_node(const char* name){
	//printf("create node\n");
	node* n = (node *) malloc(sizeof(node));
	n->name = strdup(name);
	n->next = NULL;
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
	if (temp->next == NULL){
		temp->next = n2;
	} else {
		while (temp->next != NULL){
			temp = temp->next;
		}
		temp->next = n2;
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
	printf("%s\n", n->name);
	print_tree(level + 1, n->son);
	print_tree(level, n->next);
}

void free_tree(node* n){
	//printf("free tree\n");
	if (n == NULL){
		return;
	}
	if (n->son != NULL){
		free_tree(n->son);
	}
	if (n->next != NULL){
		free_tree(n->next);
	}
	free(n->name);
	free(n);
}

