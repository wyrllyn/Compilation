%{
#include <stdio.h>
#include <string.h>
#include "table.h"

extern int yyparse();

int line = 0;

int yylex();
void yyerror(char const* s);
extern FILE* yyin;

%}
%error-verbose
%union {
	int integer;
}

%union {
	float real;
}

%union {
	char* string;
}

%token FLOAT
%token INT
%token AFF
%token DIFF
%token INF_EQUAL
%token SUP_EQUAL
%token INF
%token SUP
%token COLON
%token DIV
%token MOD
%token VAR
%token INTEGER
%token REAL
%token CHAR
%token BOOLEAN
%token IF
%token THEN
%token ELSE
%token WHILE
%token DO
%token READLN
%token WRITELN
%token PROCEDURE
%token FUNCTION
%token PROGRAM
%token BEGIN_BLOCK
%token END_BLOCK
%token BIG_END
%token VAR_ID

%%
program:
	all BIG_END {
};

type:
	FLOAT | INT | REAL | CHAR | BOOLEAN {
};

all:  FLOAT
| INT
| AFF
| DIFF
| INF_EQUAL
| SUP_EQUAL
| INF
| SUP
| COLON
| DIV
| MOD
| VAR
| INTEGER
| REAL
| CHAR
| BOOLEAN
| IF
| THEN
| ELSE
| WHILE
| DO
| READLN
| WRITELN
| PROCEDURE
| FUNCTION
| PROGRAM
| BEGIN_BLOCK
| END_BLOCK
| VAR_ID
| all

%%

int main(int argc, char* argv[]) {
	init_table(50);
	FILE* f = NULL;
	if (argc > 1) {
		f = fopen(argv[1], "r");
		if (f == NULL) {
			fprintf(stderr, "Impossible d'ouvrir %s\n", argv[1]);
			return -1;
		}
		yyin = f;
	}
	yyparse();
	// My code goes here	

	// My code ends here
	if (f != NULL) {
		fclose(f);
	}
}

void yyerror(char const* s) {
	fprintf(stderr, "Ligne %d, Erreur: %s.\n", line, s);
}
