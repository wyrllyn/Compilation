#include "utils.h"

char* copy(char* toCopy) {
	char* temp = malloc(sizeof(toCopy));
	strcpy(temp, toCopy);
	return temp;
}

char* copy_3(char* first, char* second, char* third) {
	char* temp = malloc(sizeof(char)*strlen(first) + sizeof(char)*strlen(second) + sizeof(char)*strlen(third) + sizeof(char)*3);
	strcat(temp,first);
	if (first[strlen(first) - 1] != '\n' && first[strlen(first) - 1] != '\t')
		strcat(temp," ");
	strcat(temp, second);
	if (second[strlen(second) - 1] != '\n' && second[strlen(second) - 1] != '\t')
		strcat(temp," ");
	strcat(temp, third);
	return temp;
}


Type* fillTypes(Type toAdd, Type* params) {
	Type * temp = malloc(sizeof(Type) * (sizeTypesParam + 1));
	if (params != NULL) {
		for (int i = 0; i < sizeTypesParam; i++) {
			temp[i] = params[i];
		}
	}
	temp[sizeTypesParam] = toAdd;

	return temp;
}

char * getType(char * type) {
	char * temp = "";
	if (strcmp(type, "INTEGER") == 0) {
		temp = malloc(sizeof(char)*4);
		temp = "int";	
	}
	else if (strcmp(type, "CHAR") == 0) {
		temp = malloc(sizeof(char)*5);
		temp = "char";	
	}
	else if (strcmp(type, "BOOLEAN") == 0) {
		temp = malloc(sizeof(char)*4);
		temp = "int";	
	}
	else {
		yyerror("INVALID TYPE");
	}
	return temp;
}

char* getTypeStr(Type type) {
	char * temp = "";
	switch (type) {
	case T_INT:
		temp = malloc(sizeof(char)*4);
		temp = "int";	
		break;
	case T_CHAR:
		temp = malloc(sizeof(char)*5);
		temp = "char";	
		break;
	case T_BOOLEAN:
		temp = malloc(sizeof(char)*4);
		temp = "int";
		break;
	}
	return temp;
}

Type returnType(char* type) {
	Type temp = UNKNOWN;
	if (strcmp(type, "INTEGER") == 0) {
		temp = T_INT;	
	}
	else if (strcmp(type, "CHAR") == 0) {
		temp = T_CHAR;	
	}
	else if (strcmp(type, "BOOLEAN") == 0) {
		temp = T_BOOLEAN;	
	}
	return temp;
}

char* indentation(int ind) {
	char* indent_str = malloc((sizeof(char) * ind) + 2);
	indent_str[0] = '\n';
	for(int i = 1; i <= ind; i++) {
		indent_str[i] = '\t';
	}
	indent_str[ind + 1] = '\0';
	return indent_str;
}




char* remove_file_extension(char* name) {
	int length = strlen(name);
	int point_index = length;

	for (int i = length; i > 0; i--) {
		if (name[i] == '.') {
			point_index = i;
			break;
		}
	}

	char* res = malloc(sizeof(char) * (point_index + 1));
	for (int i = 0; i < point_index; i++) {
		res[i] = name[i];
	}
	res[point_index] = '\0';

	return res;
}

void compile(char* name) {

	char* nameless = remove_file_extension(name);
	char* cmd_line[] = { name, "-o", nameless, "-std=c99"};
	
	int pid = fork();
	if (pid == 0) {
		printf("\ngcc");
		for (int i = 0; i < 4; i++) {
			printf(" %s", cmd_line[i]);
		}
		execv("/usr/bin/gcc", cmd_line);
	}
}
