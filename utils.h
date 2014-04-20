#ifndef UTILS_H
#define UTILS_H

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include "table.h"

extern int sizeTypesParam;
extern void yyerror(char const* s);

char* copy(char* toCopy);
char* copy_3(char* first, char* second, char* third);
Type* fillTypes(Type toAdd, Type* params);
char * getType(char * type);
char* getTypeStr(Type type);
Type returnType(char* type);
char* indentation(int ind);



char* remove_file_extension(char* name);
void compile(char* name);

#endif
