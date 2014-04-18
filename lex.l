%{
#include "compiler.tab.h"

extern int line;

char* copy(char* toCopy) {
	char* temp = malloc(sizeof(toCopy));
	strcpy(temp, toCopy);
	return temp;
}

%}

CHIFFRE[0-9]
LETTRE [a-zA-Z]
id ([a-zA-Z]|_)([a-zA-Z]|[0-9]|_)*
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
	yylval.type_string = copy(yytext);
	return NBR;
}


"+" {
	yylval.type_string = copy(yytext);
	return PLUS;
}


"-" {
	yylval.type_string = copy(yytext);
	return MINUS;
}

"/" {
	yylval.type_string = copy(yytext);
	return DIVIDE;
}

"*"  {
	yylval.type_string = copy(yytext);
	return TIMES;
}

";"|"," {
	yylval.type_string = copy(yytext);
	return yytext[0];
}

"("|")" {
	yylval.type_string = copy(yytext);
	return yytext[0];
}

"and" {
	yylval.type_string = copy(yytext);
	return AND;
}

"or" {
	yylval.type_string = copy(yytext);
	return OR;
}

"not" {
	yylval.type_string = copy(yytext);
	return NOT;
}

"div" {
	yylval.type_string = copy(yytext);
	return DIV;
}

"mod" {
	yylval.type_string = copy(yytext);
	return MOD;
}

"var" {
	yylval.type_string = copy(yytext);
	return VAR;
}

"integer" {
	yylval.type_string = copy(yytext);
	return INTEGER;
}

"char" {
	yylval.type_string = copy(yytext);
	return CHAR;
}

"boolean" {
	yylval.type_string = copy(yytext);
	return BOOLEAN;
}

"if" {
	yylval.type_string = copy(yytext);
	return IF;
}

"then" {
	yylval.type_string = copy(yytext);
	return THEN;
}

"else" {
	yylval.type_string = copy(yytext);
	return ELSE;
}

"while" {
	yylval.type_string = copy(yytext);
	return WHILE;
}

"do" {
	yylval.type_string = copy(yytext);
	return DO;
}

"readln(" {
	BEGIN(READ);
	yylval.type_string = copy(yytext);
	return READLN;
}

<READ>({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*")" {
	yylval.type_string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.type_string, yytext, yyleng - 1);
	yylval.type_string = copy(yytext);
	// save it ?
	BEGIN(INITIAL);
	return ID_TO_READ;
	
}

"writeln(" {
	BEGIN(WRITE);
	yylval.type_string = copy(yytext);
	return WRITELN;
}


<WRITE>({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*")" {
/* an id */
	yylval.type_string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.type_string, yytext, yyleng - 1);
	// save it ? 
	BEGIN(INITIAL);
	return ID_TO_WRITE;
}


<WRITE>({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*"("({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*"))" {
// a function
	yylval.type_string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.type_string, yytext, yyleng - 1);
	BEGIN(INITIAL);
	return FUNCTION_TO_WRITE;
}

<WRITE>\'.*\'")" {
// a string
	yylval.type_string = (char*)malloc((yyleng)*sizeof(char));
	strncpy(yylval.type_string, yytext, yyleng - 1);
	BEGIN(INITIAL);
	return STRING_TO_WRITE;
}


"function" {
	yylval.type_string = copy(yytext);
	return FUNCTION;
}

"procedure" {
	yylval.type_string = copy(yytext);
	return PROCEDURE;
}

"begin" {
	yylval.type_string = copy(yytext);
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
	yylval.type_string = copy(yytext);
	return END_BLOCK;
}
"end." {
	yylval.type_string = copy(yytext);
	return BIG_END;
}

({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)* {
	yylval.type_string = (char*)malloc((yyleng+1)*sizeof(char));
	strncpy(yylval.type_string, yytext, yyleng + 1);
	table_add_id(yylval.type_string);
	yylval.type_string = copy(yytext);
	return VAR_ID;
}

"<=" {
	yylval.type_string = copy(yytext);
	return INF_EQUAL;
}

"<>" {
	yylval.type_string = copy(yytext);
	return DIFF;
}

"<" {
	yylval.type_string = copy(yytext);
	return INF;
}


">=" {
	yylval.type_string = copy(yytext);
	return SUP_EQUAL;
}

">" {
	yylval.type_string = copy(yytext);
	return SUP;
}

":" {
	yylval.type_string = copy(yytext);
	return COLON;
}

":=" {
	yylval.type_string = copy(yytext);
	return AFF;
}

"=" {
	yylval.type_string = copy(yytext);
	return yytext[0];
}

. {
	printf("erreur: \"%s\" est un caractère inconnu. (ligne %d)\n", yytext, line);
}

