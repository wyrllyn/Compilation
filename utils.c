#include "utils.h"

char* remove_file_extension(char* name) {
	int length = strlen(name);
	int point_index = length;
	for (int i = length; i > 0; i--) {
		if (name[i] == '.') {
			point_index = i;
			break;
		}
	}

	char* res = malloc(sizeof(char) * point_index);
	
	for (int i = 0; i < point_index; i++) {
		res[i] = name[i];
	}
	return res;
}
