%{
#include <stdio.h>
#include <string.h>

extern int yyparse();

int yylex();
void yyerror(char const* s);
extern FILE* yyin;

%}

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
	"end." {
};

%%

int main(int argc, char* argv[]) {
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
	fprintf(stderr, "Erreur: %s.\n", s);
}
