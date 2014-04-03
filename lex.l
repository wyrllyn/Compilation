%{
#include "compiler.tab.h"

extern int line;
%}

CHIFFRE[0-9]
LETTRE [a-zA-Z]
id ({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*
%x COMMENTAIRE
%x READ
%x WRITE

%%


"program" {
	return PROGRAM;
}

[ \t] {
}

\n {
	line++;
}

{CHIFFRE}+ {
	yylval.integer = atoi(yytext);
	return NBR;
}


"-"|"+"|"/"|"*"|"("|")"|";"|","|"%" {
	return yytext[0];
}

"and" {
	return AND;
}

"or" {
	return OR;
}

"not" {
	return NOT;
}

"div" {
	return DIV;
}

"mod" {
	return MOD;
}

"var" {
	return VAR;
}

"integer" {
	return INTEGER;
}

"char" {
	return CHAR;
}

"boolean" {
	return BOOLEAN;
}

"if" {
	return IF;
}

"then" {
	return THEN;
}

"else" {
	return ELSE;
}

"while" {
	return WHILE;
}

"do" {
	return DO;
}

"readln(" {
	BEGIN(READ);
	return READLN;
}

<READ>({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*")" {
	yylval.string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng - 1);
	printf("\n to read %s \n", yylval.string);
	// save it ?
	BEGIN(INITIAL);
	return ID_TO_READ;
	
}

"writeln(" {
	BEGIN(WRITE);
	return WRITELN;
}


<WRITE>({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*")" {
/* an id */
	yylval.string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng - 1);
	printf("\n to write %s \n", yylval.string);
	// save it ? 
	BEGIN(INITIAL);
	return ID_TO_WRITE;
}


<WRITE>"." {
// a string
	yylval.string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng - 1);
	printf("\n to write %s \n", yylval.string);
	BEGIN(INITIAL);
	return STRING_TO_WRITE;
}


"function" {
	return FUNCTION;
}

"procedure" {
	return PROCEDURE;
}

"begin" {
	return BEGIN_BLOCK;
}

"{" {
	BEGIN(COMMENTAIRE);
}

<COMMENTAIRE>^["}"] {
}

<COMMENTAIRE>"\n" {
	line++;
}

<COMMENTAIRE><<EOF>> {
	printf("commentaire non terminé\n");
}

<COMMENTAIRE>"}" {
	BEGIN(INITIAL);
}

"end" {
	printf("end normal \n");
	return END_BLOCK;
}
"end." {
	printf("end. \n");
	return BIG_END;
}

({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)* {
	yylval.string = (char*)malloc((yyleng+1)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng + 1);
	table_add_id(yylval.string);
	return VAR_ID;
}

"<=" {
	return INF_EQUAL;
}

"<>" {
	return DIFF;
}

"<" {
	return INF;
}


">=" {
	printf(">= \n");
	return SUP_EQUAL;
}

">" {
	printf("> \n");
	return SUP;
}

":" {
	return COLON;
}

":=" {
	return AFF;
}

"=" {
	return yytext[0];
}

. {
	printf("erreur: \"%s\" est un caractère inconnu. (ligne %d)\n", yytext, line);
}

