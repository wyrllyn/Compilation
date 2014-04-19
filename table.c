#include "table.h"

int table_size = 50;
int current_size_cell = 0;
int current_size_variables = 0;

void init_table(int size) {
	table = (Cell*)malloc(sizeof(Cell) * size);
}

void table_add_id(char* id, int force) {
	// bump table size if required
	if (current_size_cell == table_size || current_size_variables == table_size ) {
		Cell* temp = malloc(sizeof(Cell) * table_size + 10);
		for (int i = 0; i < table_size; i++) {
			temp[i] = table[i];
		}
		free(table);
		table = temp;
		table_size = table_size + 10;
	}
	if (force == 1 || table_contains(id) == 0) {
		table[current_size_cell].id = id;
		table[current_size_cell].type = UNKNOWN;
		table[current_size_cell].parameters = NULL;
		table[current_size_cell].pSize = 0;
		table[current_size_cell].line = -1;
		table[current_size_cell].end = -1;
		table[current_size_cell].into = NULL;
		current_size_cell++;
	}
}

void set_temp_func(char* func) {
	for (int i = 0; i < table_size; i++) {
		if (table[i].into != NULL && strcmp(table[i].into, "TEMP_FUNC") == 0) {
			table[i].into = func;
		}
	}
}

void add_into(char* id, char* func) {
	table[table_index(id)].into = func;
}


void table_add_type_to_id(char* id, Type type) {
	if (table[table_index(id)].type == UNKNOWN)
		table[table_index(id)].type = type;
}

void setEndLine(char* id, int end) {
	table[table_index(id)].end = end;
}


void addParameters(char* func, Type* params, int size) {
	table[table_index(func)].parameters = malloc(sizeof(Type) * size);
	table[table_index(func)].pSize = size;
	for (int i = 0; i < size ; i++) {
		table[table_index(func)].parameters[i] = params[i];
	}
}

void addLine(int l, int index) {
	if (table[index].line == -1)
		table[index].line = l;
}

int table_index(char* id){
	if (!table_contains(id)) {
		printf("unknown id \n");
		return -1;
	}
	for (int i = 0; i < current_size_cell; i++) {
		if (strcmp(table[i].id, id) == 0) {
			return i;
		}
	}
}

int table_contains(char* id) {
	for (int i = 0; i < current_size_cell; i++) {
		if (strcmp(table[i].id, id) == 0) {
			return 1; //true
		}
	}
	return 0; //false
}



void table_print() {
	printf("\n");
	for (int i = 0; i < current_size_cell; i++) {
		printf(" \n %d: id=%s, type= : ", table[i].line, table[i].id);
		print_type(i);
		printf(" | params : ");
		print_type_params(i);
		printf(" endLine %d", table[i].end);
		printf("\n \t is into this : %s", table[i].into);
	}
}

void print_type_params(int index) {
	for (int i = 0 ; i < table[index].pSize ; i++) {
		switch ( table[index].parameters[i] ) {
			case T_PROGRAM:
	 		 	printf(" PROGRAM ");
	 		 break;
			case T_BOOLEAN:
	  			printf(" BOOLEAN ");
	 		 break;
			case T_INT:
	  			printf(" INT ");
	 		 break;
			case T_CHAR:
	  			printf(" CHAR ");
	 		 break;

			default:
	 		 	printf(" DOES NOT HAVE A TYPE ");
	 		 break;
		}
	}
}




void print_type(int index) {

	switch ( table[index].type ) {
		case T_PROGRAM:
 		 	printf(" PROGRAM ");
 		 break;
		case T_BOOLEAN:
  			printf(" BOOLEAN ");
 		 break;
		case T_INT:
  			printf(" INT ");
 		 break;
		case T_CHAR:
  			printf(" CHAR ");
 		 break;

		default:
 		 	printf(" DOES NOT HAVE A TYPE ");
 		 break;
	}
}

void delete_tables(){
	free(table);
};
