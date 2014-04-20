%{

#include "table.h"
#include "utils.h"

extern int yyparse();

int line = 1;
int indent = 0;
int nbrs = 0;

int yylex();
void yyerror(char const* s);
extern FILE* yyin;

FILE* out;


Type g_type = UNKNOWN;
Type * typesParam = NULL;
int sizeTypesParam = 0;
int incWD = 0;

int inFunction = 0;
char* currentFunc = NULL;

//// optional arguments stuff
#define COMPARE(x, y) strcmp(x, y) == 0
int printTable = 1;
int printC = 1;
int createC = 1;

void dealWithArgs(int argc, char* argv[]) {
	for (int i = 2; i < argc; i++) {
		if (COMPARE(argv[i], "-noTable")) {
			printTable = 0;
		} else if (COMPARE(argv[i], "-printTable")) {
			printTable = 1;
		} else if (COMPARE(argv[i], "-noCPrint")) {
			printC = 0;
		} else if (COMPARE(argv[i], "-noCFile")) {
			createC = 0;
		}
	}
}

%}
%error-verbose

%left INF SUP DIFF INF_EQUAL SUP_EQUAL NOT OR AND '='
%left PLUS MINUS
%left DIVIDE TIMES DIV
%right MOD

%nonassoc IFX
%nonassoc ELSE


%union {
	int integer;
}

%union {
	char* type_string;
}


%token<type_string> NBR
%token<type_string> AFF
%token<type_string> DIFF
%token<type_string> INF_EQUAL
%token<type_string> SUP_EQUAL
%token<type_string> INF
%token<type_string> SUP
%token<type_string> COLON
%token<type_string> DIV
%token<type_string> MOD
%token<type_string> VAR
%token<type_string> INTEGER
%token<type_string> CHAR
%token<type_string> BOOLEAN
%token<type_string> IF
%token<type_string> THEN
%token<type_string> ELSE
%token<type_string> WHILE
%token<type_string> DO
%token<type_string> READLN
%token<type_string> WRITELN
%token<type_string> PROCEDURE
%token<type_string> FUNCTION
%token<type_string> PROGRAM
%token<type_string> BEGIN_BLOCK
%token<type_string> END_BLOCK
%token<type_string> BIG_END
%token<type_string> VAR_ID
%token<type_string> AND
%token<type_string> OR
%token<type_string> NOT
%token<type_string> ID_TO_READ
%token<type_string> ID_TO_WRITE
%token<type_string> STRING_TO_WRITE
%token<type_string> FUNCTION_TO_WRITE
%token<type_string> PLUS
%token<type_string> MINUS
%token<type_string> DIVIDE
%token<type_string> TIMES
%token<type_string> BOOL_CONDITION

%type<type_string> type;
%type<type_string> expr;
%type<type_string> affect;
%type<type_string> ids;
%type<type_string> function_var;
%type<type_string> main_var;
%type<type_string> followed_by;
%type<type_string> declaration;
%type<type_string> params;
%type<type_string> params_not_empty;
%type<type_string> procedure_header;
%type<type_string> endFound;
%type<type_string> if_then;
%type<type_string> instruct_single;
%type<type_string> both_instructs;
%type<type_string> block;
%type<type_string> while_block;
%type<type_string> instruct_multiple;
%type<type_string> read_n_write;
%type<type_string> core;
%type<type_string> main;
%type<type_string> function;
%type<type_string> procedure;
%type<type_string> procedure_core;
%type<type_string> program;
%type<type_string> pg;
%type<integer> endFunc;



%%

program: pg core main {

	$$ = copy_3($1, $2, $3);
	
	if (printC)
		printf("\n %s", $$);
	if (createC)
		fprintf(out, "%s", $$);
};

/////////////////DONE ////////////////////

pg: PROGRAM VAR_ID ';' {
	table_add_type_to_id($2, T_PROGRAM);
	$$ = copy_3("#include<stdio.h> \n#include<stdlib.h>", "\n\n", "");
	
};

//////////  DONE /////////////////

core: function core {
	$$ = copy_3($1,$2, "");

}
|
procedure core {
	$$ = copy_3($1,$2, "");
}
| {
	$$ = "\n";
};

////////////////   DONE ///////

main: main_var beginFound instruct_multiple BIG_END {
	$$ = copy_3("int main(int argc, char ** argv) { \n", $1, $3);
	
	$$ = copy_3($$, "\n}", "");
};

procedure_header: PROCEDURE VAR_ID '(' params ')'';' {


	currentFunc = $2;
	addParameters($2, typesParam,  sizeTypesParam);

	free(typesParam);
	sizeTypesParam = 0;
	typesParam = NULL;

	$$ = copy_3("void", $2, "(");
	$$ = copy_3($$, $4, ")");
	$$ = copy_3($$, "{", indentation(indent));
	indent++;
};

procedure: procedure_header function_var procedure_core {

	set_temp_func(currentFunc);
	inFunction = 0;
	$$ = copy_3($1, $2, indentation(indent));
	$$ = copy_3($$, $3, indentation(indent));
};


function: FUNCTION VAR_ID '(' params ')' COLON type ';'
function_var beginFound instruct_multiple endFunc';'
{	
	table_add_type_to_id($2, returnType($7));
	addParameters($2, typesParam, sizeTypesParam);

	inFunction = 0;

	currentFunc = $2;
	set_temp_func($2);

	setEndLine(currentFunc, $12);
	currentFunc = "";

	free(typesParam);
	sizeTypesParam = 0;
	typesParam = NULL;

	$$ = copy_3(getType($7), $2, "(");
	$$ = copy_3($$, $4, ")");
	indent = 1;
	$$ = copy_3($$, "{", indentation(indent));
	$$ = copy_3($$, getType($7), $2);
	$$ = copy_3($$, ";", indentation(indent));
	$$ = copy_3($$, $9, $11);
	$$ = copy_3($$, indentation(indent), "return");
	$$ = copy_3($$, $2, ";");
	$$ = copy_3($$, "\n", indentation(indent));

	$$ = copy_3($$, "}", "\n");
};


///////////////////////////// DONE   /////////////////////////


type: INTEGER { $$ = "INTEGER"; }
| CHAR { $$ = "CHAR";}
| BOOLEAN { $$ = "BOOLEAN";
};

/////////////////////////////////////// DONE ////////

params: params_not_empty {
	
	inFunction = 1;
	incWD = 1;
	$$ = $1;
}
| {

	inFunction = 1;
	incWD = 1;
	$$ = "";
};


params_not_empty: ids {
	$$ = $1;
	g_type = UNKNOWN;
}
| ids ',' params_not_empty {
	$$ = copy_3($1, ",", $3);
	g_type = UNKNOWN;
};

ids: VAR_ID ',' ids {
	if (incWD == 1) {
		$$ = copy_3($3, ",", $1);
	} else {
		$$ = copy_3($3, ",", getTypeStr(g_type));
		$$ = copy_3($$, $1, "");
	}
	//////
	if (table_contains($1)) {
		if (table[table_index($1)].into != NULL && strcmp(table[table_index($1)].into, "TEMP_FUNC") == 0) {
			yyerror(" La variable a déjà été déclarée");
		}
	}
	//////
	table_add_type_to_id($1, g_type);
	if (incWD == 0) {
		typesParam = fillTypes(g_type, typesParam);
		sizeTypesParam++;
		add_into($1, "TEMP_FUNC");
	}
	if (inFunction == 1) {
		add_into($1, "TEMP_FUNC");
	}

}
| VAR_ID COLON type {
	table_add_type_to_id($1, returnType($3));
	g_type = returnType($3);
	char* temp = getType($3);
	
	if (incWD == 0) {
		typesParam = fillTypes(returnType($3), typesParam);
		sizeTypesParam++;
		add_into($1, "TEMP_FUNC");
	}

	if (inFunction == 1) {
		add_into($1, "TEMP_FUNC");
	}

	$$ = copy_3(temp, $1, "");
};

///////////////////////////////////////// DONE //////

function_var: VAR declaration {
	incWD = 0;
	indent = 1;
	$$ = $2;
}
| {
	incWD = 0;
	indent = 1;
	$$ = "";
};

main_var: VAR declaration {
	free(typesParam);
	sizeTypesParam = 0;
	typesParam = NULL;
	
	indent = 1;
	$$ = copy_3(indentation(indent), $2, "");
	
} |
 {	
	indent = 1;
	$$ = "";
};

declaration: ids ';' followed_by {
	indent = 1;
	$$ = copy_3($1,";", "");
	$$ = copy_3($$, indentation(indent), $3);
};


followed_by: VAR ids ';' followed_by  {
	indent = 1;
	$$ = copy_3($2, ";", "");
	$$ = copy_3($$, indentation(indent), $4);
}
| {
	indent = 1;
	$$ = "";
};


////////////////// DONE /////////////////////////

procedure_core: beginFound instruct_multiple endFunc';' {
	
	setEndLine(currentFunc, $3);
	$$ = copy_3($2,indentation(indent), "}") ;
};

//////////////////////////////////

block: beginFound instruct_multiple endFound';' {
	$$ = copy_3("", $2, $3);
} | 
beginFound endFound ';' {
	$$ = copy_3(indentation(indent), $2, "");
};


while_block: WHILE expr DO block {
	$$ = copy_3("while", $2, "{");
	indent++;
	$$ = copy_3($$, "", $4);
	
}; 

instruct_multiple: affect instruct_multiple {
	$$ = copy_3(indentation(indent),$1, $2);
}
| instruct_single {
	$$ = $1;
}
| if_then instruct_multiple {
	$$ = copy_3(indentation(indent),$1, $2);
}
| read_n_write instruct_multiple {
	$$ = copy_3(indentation(indent),$1, $2);
}
| while_block instruct_multiple{
	$$ = copy_3(indentation(indent),$1, $2);
};


//////TODO
read_n_write: READLN ID_TO_READ ';' {
 //verification of ID_TO_READ presence into symbol table
	$$ = copy_3($1,")",";");
}
| WRITELN ID_TO_WRITE ';' {	
	$$ = copy_3($1,")",";");
}
| WRITELN FUNCTION_TO_WRITE ';' {
	$$ = copy_3($1,")",";");
}
| WRITELN STRING_TO_WRITE ';' {
	$$ = copy_3($1,")",";");
};


instruct_single: affect {
	$$ = copy_3(indentation(indent), $1, "");
}
| if_then {
	$$ = copy_3(indentation(indent), $1, "");
}
| read_n_write {
	$$ = copy_3(indentation(indent), $1, "");
}
| while_block {
	$$ = copy_3(indentation(indent), $1, "");
};

both_instructs: block {
	$$ = $1;
}
| instruct_single {
	$$ = $1;
} ;


if_then: IF expr THEN both_instructs %prec IFX {
	$$ = copy_3("if", $2, $4);
}
| IF expr THEN both_instructs ELSE both_instructs {
	$$ = copy_3("if", "(", $2);
	$$ = copy_3($$, ")", indentation(indent));
	$$ = copy_3($$, $4, indentation(indent));
	$$ = copy_3($$, "else", $6);	
};


expr: NBR { 
	$$ = $1;
}
| VAR_ID { 
	$$ = $1;
}
| BOOL_CONDITION {
	if ( strcmp($1, "true") == 0)
		$$ = "1";
	else
		$$ = "0";
}

| expr PLUS expr {
	$$ = copy_3($1, $2, $3);
}

| expr MINUS expr {
	$$ = copy_3($1, $2, $3);
}

| expr TIMES expr {
	$$ = copy_3($1, $2, $3);
}

| expr DIVIDE expr {
	$$ = copy_3($1, $2, $3);
}
| expr MOD expr {
	$$ = copy_3($1, "%", $3);
}
| expr DIV expr {
	$$ = copy_3($1, $2, $3);
}
| expr DIFF expr {
	$$ = copy_3($1, "!=", $3);
	$$ = copy_3("(", $$, ")");
}
| '(' expr ')' {
	$$ = copy_3("(", $2, ")");
}
| expr SUP expr {
	$$ = copy_3($1, $2, $3);
	$$ = copy_3("(", $$, ")");
}
| expr INF expr {
	$$ = copy_3($1, $2, $3);
	$$ = copy_3("(", $$, ")");
}
| expr '=' expr {
	$$ = copy_3($1, "==", $3);
	$$ = copy_3("(", $$, ")");
}
| expr SUP_EQUAL expr {
	$$ = copy_3($1, $2, $3);
	$$ = copy_3("(", $$, ")");
}
| expr INF_EQUAL expr {
	$$ = copy_3($1, $2, $3);
	$$ = copy_3("(", $$, ")");
}
| expr AND expr {
	$$ = copy_3($1, "&&", $3);
	$$ = copy_3("(", $$, ")");
}
| expr OR expr {
	$$ = copy_3($1, "||", $3);
	$$ = copy_3("(", $$, ")");
}
| NOT expr {
	$$ = copy_3($1, $2, "");
	$$ = copy_3("(", $$, ")");
};

affect: VAR_ID AFF expr ';' { 
	$$ = copy_3($1, "=", $3);
	$$ = copy_3($$, ";", "");
};

/////////////// DONE //////////////////////

beginFound: BEGIN_BLOCK {
};

endFound: END_BLOCK {
	indent--;
	$$ = copy_3(indentation(indent), "}", "");
};

endFunc: END_BLOCK {	
	indent--;
	
	$$ = line;
	//$$ = copy_3(indentation(indent), "}", "");
	
};

%%

int main(int argc, char* argv[]) {
	init_table(50);
	FILE* f = NULL;
	char* name;
	
	if (argc > 1) {
		// open input file
		f = fopen(argv[1], "r");
		if (f == NULL) {
			fprintf(stderr, "Impossible d'ouvrir %s\n", argv[1]);
			return -1;
		}
		yyin = f;

		if (argc > 2)
			dealWithArgs(argc, argv);

		// manage output file
		if (createC) {
			name = remove_file_extension(argv[1]);
			strcat(name, ".c");
			printf("\n### Writing in file %s ###\n", name);
			out = fopen(name,"w");
		}
	}
	yyparse();

	if (printTable)
		table_print();

	if (f != NULL) {
		fclose(f);
	}

	if (out != NULL) {
		fclose(out);
		compile(name);
	}

	delete_tables();
	printf("\n");
}

void yyerror(char const* s) {
	fprintf(stderr, "Ligne %d, Erreur: %s.\n", line, s);
}
