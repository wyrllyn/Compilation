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
		usleep(100);
		execv("/usr/bin/gcc", cmd_line);
	}
}
