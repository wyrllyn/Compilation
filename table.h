#ifndef TABLE_H
#define TABLE_H

#include <stdio.h>
#include <stdlib.h>

enum t_type {
	T_FLOAT,
	T_INT,
	T_REAL,
	T_CHAR,
	T_BOOLEAN,
	T_FUNCTION
};
typedef enum t_type Type;

struct t_cell {
	char* id;
	Type type;
};
typedef struct t_cell Cell;

Cell* table;
int table_size = 50;
int current_size = 0;

void init_table(int size);
void table_add_id(char* id);
void table_add_type_to_id(char* id, Type type);
void table_print();

#endif
