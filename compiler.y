%{
#include <stdio.h>
#include <string.h>
#include "table.h"

extern int yyparse();

int line = 1;

int yylex();
void yyerror(char const* s);
extern FILE* yyin;

%}
%error-verbose

%left INF SUP DIFF INF_EQUAL SUP_EQUAL NOT OR AND
%left '+' '-'
%left '*' '/' DIV

%union {
	int integer;
}

%union {
	char* string;
}

%token NBR
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
%token AND
%token OR
%token NOT

%%

program: pg core BIG_END {
};

/////////////////////////////////////

pg: PROGRAM VAR_ID ';' {
	
};

///////////////////////////

core: function core {

}
|
procedure core {

}
| main {
};

///////////////////////

main: BEGIN_BLOCK {
};

function: function_header function_var function_core {
};

procedure: procedure_header function_var procedure_core {

};

//////////////////////////////////////////////////////

function_header: FUNCTION VAR_ID '(' params ')' COLON type ';' {
	printf("header\n");
};

procedure_header: PROCEDURE VAR_ID '(' params ')'';' {

}

type: INTEGER {}
| CHAR {}
| BOOLEAN {
};

///////////////////////////////////////

params: params_not_empty {}
| {};


params_not_empty: ids COLON type {
}
| ids COLON type ',' params_not_empty {
};

ids: VAR_ID','ids {
	printf("id,\n");
}
| VAR_ID {
	printf("id\n");
};

/////////////////////////////////////////

function_var: VAR declaration {};

declaration: ids COLON type followed_by ';' {};


followed_by: ids COLON type followed_by ';' {}
| {};


///////////////////////////////////////////

function_core: block {};

procedure_core: block {};

//////////////////////////////////

block: BEGIN_BLOCK instruct END_BLOCK {};

instruct: affect instruct {}
| {}
| while_block instruct{};

while_block: WHILE expr DO {}; 


expr: NBR {}
| VAR_ID {}
| expr '+' expr {
	printf("addition joie");}
| expr '-' expr {}
| expr '*' expr {}
| expr '/' expr {} //division
| expr DIV expr {} //quotient
| expr DIFF expr {}
| expr SUP expr {}
| expr INF expr {}
| expr SUP_EQUAL expr {}
| expr INF_EQUAL expr {}
| expr AND expr {}
| expr OR expr {}
| NOT expr {};

affect: VAR_ID AFF expr ';' {};

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
	table_print();

	// My code ends here
	if (f != NULL) {
		fclose(f);
	}
}

void yyerror(char const* s) {
	fprintf(stderr, "Ligne %d, Erreur: %s.\n", line, s);
}
