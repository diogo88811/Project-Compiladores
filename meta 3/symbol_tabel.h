#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

typedef struct secondaryTable{
    char *id;
    char *type;
    char *param;
    struct secondaryTable* next;
}secondaryTable;

typedef struct table{
    char *name;
    char *type;
    char *params;
    bool begin;

    struct secondaryTable *t;
    struct table *next;
}table;

void globalTable();
void insert_data(char *id, char *type,char *params, char *name);
void funcTabel(char *name, char * params, bool b );
void print_tables();
void insert_data_functtable(char *id, char* type,char*param, char*name);
void manipulate(char *str, char c);
void word(char *str);
char* find_table(char *id, char *tableName);