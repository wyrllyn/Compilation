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
	char* id; //var id
	Type type; // type of the var
	Type * parameters; // if function or procedure type of the parameters
	int pSize; // size of *parameters
	int line; // line of the var declaration
	int end; // line of the end if function
	char* into; // is the var into a function / procedure ? if yes : which one 
};	
typedef struct t_cell Cell;

Cell* table;

void init_table(int size);
void table_add_id(char* id, int force);
void add_into(char* id, char* func);
void table_add_type_to_id(char* id, Type type);
void addParameters(char* func, Type* params, int size);
int table_contains(char* id);
void setEndLine(char* id, int end);
int table_index(char* id);
void table_add_type_to_id(char* id, Type type);
void table_print();
void print_type(int index);
void print_type_params(int index);
void delete_tables();
void set_temp_func(char* func);

#endif
