%{
#include "compiler.tab.h"

extern int line;
%}

CHIFFRE[0-9]
LETTRE [a-zA-Z]
id ({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)*
%x COMMENTAIRE
%x INFERIOR
%x SUPERIOR
%x DP
%x END_BOTH

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
	return INT;
}

[CHIFFRE]+("."[CHIFFRE]*)? {
	yylval.real = atof(yytext);
	return FLOAT;
}

"-"|"+"|"/"|"*"|"("|")"|";" {
	return yytext[0];
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

"real" {
	return REAL;
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

"readln" {
	return READLN;
}

"writeln" {
	return WRITELN;
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

<COMMENTAIRE>^["}"]|"\n" {
}

<COMMENTAIRE><<EOF>> {
	printf("commentaire non terminé\n");
}

<COMMENTAIRE>"}" {
	BEGIN(INITIAL);
}

"<" {
	BEGIN(INFERIOR);
}

"end" {
	BEGIN(END_BOTH);
}

({LETTRE}|_)({LETTRE}|{CHIFFRE}|_)* {
	yylval.string = malloc((yyleng+1)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng + 1);
	table_add_id(yylval.string);
	return VAR_ID;
}

<END_BOTH>"." {
	printf("end. \n");
	return BIG_END;
	BEGIN(INITIAL);
}

<END_BOTH>^["."] {
	printf("end normal \n");
	return END_BLOCK;
	BEGIN(INITIAL);
}

<INFERIOR>"=" {
	printf("<= \n");
	return INF_EQUAL;
	BEGIN(INITIAL);
}

<INFERIOR>">" {
	printf("<> \n");
	return DIFF;
	BEGIN(INITIAL);
}

<INFERIOR>^["="">"] {
	printf("< \n");
	return INF;
	BEGIN(INITIAL);
}

">" {
	BEGIN(SUPERIOR);
}

<SUPERIOR>"=" {
	printf(">= \n");
	return SUP_EQUAL;
	BEGIN(INITIAL);
}

<SUPERIOR>^["="] {
	printf("> \n");
	return SUP;
	BEGIN(INITIAL);
}

":" {
	BEGIN(DP);
}

<DP>"=" {
	printf(":= \n");
	return AFF;
	BEGIN(INITIAL);
}

<DP>^["="] {
	printf(": \n");
	return COLON;
	BEGIN(INITIAL);
}

"=" {
	return yytext[0];
}




. {
	printf("erreur: \"%s\" est un caractère inconnu. (ligne %d)\n", yytext, line);
}

