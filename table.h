#ifndef TABLE_H
#define TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum t_type {
	T_PROGRAM,
	T_INT,
	T_CHAR,
	T_BOOLEAN,
	T_FUNCTION,
	T_PROCEDURE,
	UNKNOWN
};
typedef enum t_type Type;

struct t_cell {
	char* id;
	Type type;
	Type * parameters;
	int line;
	char* into;
};	
typedef struct t_cell Cell;

Cell* table;

void init_table(int size);
void table_add_id(char* id);
void table_add_type_to_id(char* id, Type type);
int table_contains(char* id);
int table_index(char* id);
void table_add_type_to_id(char* id, Type type);
void table_print();
void print_type(int index);
void delete_tables();

#endif
