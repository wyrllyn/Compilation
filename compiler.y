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

%left INF SUP DIFF INF_EQUAL SUP_EQUAL NOT OR AND '='
%left '+' '-'
%left '*' '/' DIV
%right MOD

%nonassoc IFX
%nonassoc ELSE

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
%token ID_TO_READ
%token ID_TO_WRITE
%token STRING_TO_WRITE
%token FUNCTION_TO_WRITE

%%

program: pg core main {
	printf("\n finished \n");
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
| {
};

///////////////////////

main: main_var BEGIN_BLOCK instruct_multiple BIG_END {
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
}
| VAR_ID {
};

/////////////////////////////////////////

function_var: VAR declaration {}
| {};

main_var: VAR declaration {} |
 {};

declaration: ids COLON type followed_by ';' {};


followed_by: ids COLON type followed_by ';' {}
| {};


///////////////////////////////////////////

function_core: block {};

procedure_core: block {};

//////////////////////////////////

block: BEGIN_BLOCK instruct_multiple END_BLOCK';' {} | 
BEGIN_BLOCK END_BLOCK ';' {};


while_block: WHILE expr DO block {}; 

instruct_multiple: affect instruct_multiple {}
| instruct_single {}
| if_then instruct_multiple {}
| read_n_write instruct_multiple {}
| while_block instruct_multiple{};

read_n_write: READLN ID_TO_READ ';' {
 //verification of ID_TO_READ presence into symbol table
}
| WRITELN ID_TO_WRITE ';' {}
| WRITELN FUNCTION_TO_WRITE ';' {
	printf("function \n");}
| WRITELN STRING_TO_WRITE ';' {};


instruct_single: affect {}
| if_then {}
| read_n_write {}
| while_block {};

both_instructs: block {}
| instruct_single {} ;


if_then: IF expr THEN both_instructs %prec IFX {}
| IF expr THEN both_instructs ELSE both_instructs {};


expr: NBR {}
| VAR_ID {}
| expr '+' expr {}
| expr '-' expr {}
| expr '*' expr {}
| expr MOD expr {}
| expr '/' expr {} //division
| expr DIV expr {} //quotient
| expr DIFF expr {}
| expr SUP expr {}
| expr INF expr {}
| expr '=' expr {}
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
