%{

#include "table.h"

extern int yyparse();

int line = 1;
int indent = 0;
int nbrs = 0;
int vrbls = 0;

int yylex();
void yyerror(char const* s);
extern FILE* yyin;

char * copy_3(char* first, char* second, char* third) {
	char* temp = malloc(sizeof(first) + sizeof(second) + sizeof(third) + sizeof(char)*2);
	strcat(temp,first);
	strcat(temp," ");
	strcat(temp, second);
	strcat(temp," ");
	strcat(temp, third);
	return temp;
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



%%

program: pg core main {
	printf("\n finished \n");
};

/////////////////////////////////////

pg: PROGRAM VAR_ID ';' {
	vrbls++;
	table_add_type_to_id($2, T_PROGRAM);
	
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

main: main_var beginFound instruct_multiple BIG_END {
};

function: function_header function_var function_core {
};

procedure: procedure_header function_var procedure_core {

};

//////////////////////////////////////////////////////

function_header: FUNCTION VAR_ID '(' params ')' COLON type ';' {
	vrbls++;
	table_add_type_to_id($2, T_FUNCTION);
	printf("header\n");
};

procedure_header: PROCEDURE VAR_ID '(' params ')'';' {
	table_add_type_to_id($2, T_PROCEDURE);

}

type: INTEGER { $$ = "INTEGER"; }
| CHAR { $$ = "CHAR";}
| BOOLEAN { $$ = "BOOLEAN";
};

/////////////////////////////////////// DONE ////////

params: params_not_empty {
	$$ = $1;
	printf(" param declare \n %s \n", $$);
}
| {
	$$ = "";
};


params_not_empty: ids {
	$$ = $1;
}
| ids ',' params_not_empty {
	$$ = copy_3($1, ",", $3);
};

ids: VAR_ID ',' ids { vrbls++;
	$$ = copy_3($3, ",", $1);
}
| VAR_ID  COLON type {
	// TYPE TODO symbol
	//#############################
	char* temp = "";
	if ($3 == "INTEGER") {
		temp = malloc(sizeof(char)*3);
		temp = "int";	
	}
	else if ($3 == "CHAR") {
		temp = malloc(sizeof(char)*4);
		temp = "char";	
	}
	else if ($3 == "BOOLEAN") {
		temp = malloc(sizeof(char)*7);
		temp = "boolean";	
	}
	else {
		printf("\n WTF %s", $3);
	}

	$$ = copy_3(temp, $1, "");
	vrbls++;
};

///////////////////////////////////////// DONE //////

function_var: VAR declaration {
	$$ = $2;
	printf("\n declare \n %s \n", $$);
}
| {
	$$ = "";
};

main_var: VAR declaration {
	$$ = $2;
} |
 {
	$$ = "";
};

declaration: ids ';' followed_by {
	$$ = copy_3($1,"; \n", $3);
};


followed_by: VAR ids ';' followed_by  {
	$$ = copy_3($2, "; \n", $4);
}
| {
	$$ = "";
};


///////////////////////////////////////////

function_core: block {};

procedure_core: block {};

//////////////////////////////////

block: beginFound instruct_multiple endFound';' {} | 
beginFound endFound ';' {};


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


expr: NBR { 
	$$ = $1;
}
| VAR_ID { 
	$$ = $1;
	vrbls++;
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
	$$ = copy_3($1, $2, $3);
}
| expr DIV expr {
	$$ = copy_3($1, $2, $3);
}
| expr DIFF expr {
	$$ = copy_3($1, "!=", $3);
}
| '(' expr ')' {
	$$ = copy_3("(", $2, ")");
}
| expr SUP expr {
	$$ = copy_3($1, $2, $3);
}
| expr INF expr {
	$$ = copy_3($1, $2, $3);
}
| expr '=' expr {
	$$ = copy_3($1, "==", $3);
}
| expr SUP_EQUAL expr {
	$$ = copy_3($1, $2, $3);
}
| expr INF_EQUAL expr {
	$$ = copy_3($1, $2, $3);
}
| expr AND expr {
	$$ = copy_3($1, "&&", $3);
}
| expr OR expr {
	$$ = copy_3($1, "||", $3);
}
| NOT expr {
	$$ = copy_3($1, $2, "");
};

affect: VAR_ID AFF expr ';' { 
	$$ = copy_3($1, "=", $3);
	$$ = copy_3($$, ";", "");
	printf("\n AFFECT  %s ", $$);
	vrbls ++;
};

/////////////////////////////////////

beginFound: BEGIN_BLOCK {indent++;};

endFound: END_BLOCK {indent--;};

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

	delete_tables();
}

void yyerror(char const* s) {
	fprintf(stderr, "Ligne %d, Erreur: %s.\n", line, s);
}
