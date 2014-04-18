#include "table.h"

int table_size = 50;
int current_size_cell = 0;
int current_size_variables = 0;
int current_size_numbers = 0;

void init_table(int size) {
	table = (Cell*)malloc(sizeof(Cell) * size);
	numbers = (int*)malloc(sizeof(int) * size);
	variables = (char**)malloc(sizeof(char*) * size);
}

void table_add_id(char* id) {
	if (current_size_cell == table_size || current_size_variables == table_size ) {
		printf("ERROR: max table size reached");
		//TODO: bump table size
	} else {
		if (table_contains(id) == 0) {
			table[current_size_cell].id = id;
			table[current_size_cell].type = UNKNOWN;
			current_size_cell++;
		}
		variables[current_size_variables] = id;
		current_size_variables++;
	}
	
}

void table_add_number(int nb) {
	if (current_size_numbers == table_size ) {
		printf("ERROR: max table size reached");
		//TODO: bump table size
	}
	else {
		numbers[current_size_numbers] = nb;
		current_size_numbers++;
	}
}

int table_index(char* id){
	if (!table_contains(id)) {
		printf("unknown id \n");
		return -1;
	}
	for (int i = 0; i < current_size_cell; i++) {
		if (strcmp(table[i].id, id) == 0) {
			printf(" ////////// %d ///////// \n ", i);
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

void table_add_type_to_id(char* id, Type type) {
	table[table_index(id)].type = type;
}

void table_print() {
	for (int i = 0; i < current_size_cell; i++) {
		printf("%d: id=%s, type= ", i, table[i].id);
		print_type(i);
	}

/*	for (int i = 0; i < current_size_variables; i++) {
		printf("%d: id=%s \n", i, variables[i]);
	} 

	for (int i = 0; i < current_size_numbers; i++) {
		printf("%d: number found = %d \n", i, numbers[i]);
	}*/
}

void print_type(int index) {

	switch ( table[index].type ) {
		case T_PROGRAM:
 		 	printf(" PROGRAM \n");
 		 break;
		case T_INT:
  			printf(" INT \n");
 		 break;
		case T_FUNCTION:
  			printf(" FUNCTION \n");
 		 break;
		case T_PROCEDURE:
  			printf(" PROCEDURE \n");
 		 break;
		default:
 		 	printf(" DOES NOT HAVE A TYPE \n");
 		 break;
	}
}

void delete_tables(){
	free(table);
	free(numbers);
	free(variables);
};
