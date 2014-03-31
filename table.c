#include "table.h"

void init_table(int size) {
	table = malloc(sizeof(Cell) * size);
}

void table_add_id(char* id) {
	if (current_size == table_size) {
		printf("ERROR: max table size reached");
		//TODO: bump table size
	} else {
		table[current_size].id = id;
		current_size++;
	}
}

void table_add_type_to_id(char* id, Type type) {

}

void table_print() {
	for (int i = 0; i < current_size; i++) {
		printf("%d: id=%s, type=TODO", i, table[i].id);
	}
}
