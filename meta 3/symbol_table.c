#include "symbol_tabel.h"

struct table *symTable = NULL;


void insert_data_functtable(char *id, char* type,char*param, char*name){
    struct secondaryTable * sTable = (struct secondaryTable *) malloc(sizeof(struct secondaryTable));
    sTable->id = id;
    sTable->type = type;
    sTable->param = param;
    sTable->next = NULL;
    struct table* mainTable = symTable;
    if(mainTable == NULL){
        printf("main table empty\n");
        return;
    }
    while(mainTable != NULL){
        if(strcmp(mainTable->name,name) == 0){
            if(mainTable->t == NULL){
                mainTable->t = sTable;  
                return;
            }
            struct secondaryTable *aux = mainTable->t;
            while(aux->next != NULL){
                if(strcmp(aux->next->id,id) == 0){
                    return;
                }
                aux = aux->next;
            }
            aux->next = sTable;
            return;
        }
        mainTable = mainTable->next;
    }
    return;
}


void insert_data(char *id, char *type,char *params, char *name){
   struct table * auxt = (struct table *)malloc( sizeof(struct table));
   auxt->name = id;
   auxt->type = type;
   auxt->params = params;
   auxt->t = NULL;
   auxt->next = NULL;


   if(symTable == NULL){
       symTable = auxt;
       return ;
   }

    struct table * aux = symTable;
    while(aux->next != NULL){
       aux = aux->next;
       if(strcmp(aux->name,id) == 0){
           return;
       }

    }
    aux->next = auxt;
    return;
}

void print_tables(){
	struct table *auxTable = symTable;
	struct secondaryTable* auxNodeTable;
    char name[30];
    printf("===== Global Symbol Table =====\n");
	while(auxTable != NULL){
        if(strcmp(auxTable->name,"putchar") != 0 && strcmp(auxTable->name,"getchar") != 0){
            strcpy(name,auxTable->name);
            word(name);
            printf("%s\t%s%s\n", name, auxTable->type,auxTable->params);
        }
        else{
            printf("%s\t%s%s\n", auxTable->name, auxTable->type,auxTable->params);
        }
        
        auxTable = auxTable->next;
    }
    auxTable = symTable;
    while(auxTable != NULL){
        if(auxTable->t != NULL){
            printf("\n");
            auxNodeTable = auxTable->t;
            strcpy(name,auxTable->name);
            word(name);
            printf("===== Function %s Symbol Table =====\n",name /*auxTable->name*/);
            while(auxNodeTable != NULL){
                if(strcmp(auxNodeTable->id,"return") != 0){
                    strcpy(name,auxNodeTable->id);
                    word(name);
                    printf("%s\t%s%s\n", name, auxNodeTable->type, auxNodeTable->param);
                }
                else{
                    printf("%s\t%s%s\n", auxNodeTable->id, auxNodeTable->type, auxNodeTable->param);
                }   
                auxNodeTable = auxNodeTable->next;
            }   
        }
        auxTable = auxTable->next;
    }
    printf("\n");
}

void word(char *str){
	int i;
	   	
  	for(i = 0; i < 3; i++){
        memmove(&str[0],&str[0 + 1], strlen(str) - 0);
	}
    memmove(&str[strlen(str) - 1],&str[strlen(str)], strlen(str) - (strlen(str) -1) );
}

char* find_table(char *id, char *tableName){
	struct table *auxTable = symTable;
    struct secondaryTable* auxSTable;
    char func[30];
	while(auxTable != NULL){
        if(strcmp(auxTable->name,tableName) == 0){
            
            auxSTable = auxTable->t;
            while(auxSTable != NULL){
                if(strcmp(auxSTable->id,id) == 0){
                    return (char * ) strdup(auxSTable->type);
                }
                auxSTable = auxSTable->next;
            }
        }
        auxTable = auxTable->next;
    }

    if(strcmp(id,"Id(getchar)") == 0){
       return "int(void)"; 
    }

    if(strcmp(id,"Id(putchar)") == 0){
       return "int(int)"; 
    }

    auxTable = symTable;
    while(auxTable != NULL){
        if(strcmp(auxTable->name,id) == 0){

            if(auxTable->t == NULL){
               if(strcmp(auxTable->params,"") != 0){
                    strcpy(func,auxTable->type);
                    strcat(func,auxTable->params);
                    return (char * ) strdup(func);    
               } 
               return (char * ) strdup(auxTable->type); 
            }
            else{
                strcpy(func,auxTable->type);
                strcat(func,auxTable->params);
                return (char * ) strdup(func);

            }
            
        }

        auxTable = auxTable->next;
    }
    return "";
}
