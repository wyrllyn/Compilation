%{
#include "compiler.tab.h"
%}

CHIFFRE[0-9]
LETTRE[a-zA-Z]
%x COMMENTAIRE
%x INFERIOR
%x SUPERIOR
%x DP
%x END_BOTH

%%

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

"program" {
	return PROGRAM;
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

<END_BOTH>"." {
	return BIG_END;
	BEGIN(INITIAL);
}

<END_BOTH>^["."] {
	return END_BLOCK;
	BEGIN(INITIAL);
}

<INFERIOR>"=" {
	return INF_EQUAL;
	BEGIN(INITIAL);
}

<INFERIOR>">" {
	return DIFF;
	BEGIN(INITIAL);
}

<INFERIOR>^["="">"] {
	return INF;
	BEGIN(INITIAL);
}

">" {
	BEGIN(SUPERIOR);
}

<SUPERIOR>"=" {
	return SUP_EQUAL;
	BEGIN(INITIAL);
}

<SUPERIOR>^["="] {
	return SUP;
	BEGIN(INITIAL);
}

":" {
	BEGIN(DP);
}

<DP>"=" {
	return AFF;
	BEGIN(INITIAL);
}

<DP>^["="] {
	return COLON;
	BEGIN(INITIAL);
}

"=" {
	return yytext[0];
}

LETTRE+(CHIFFRE*LETTRE*)* {
	/* sauvegarder l'id */
	yylval.string = malloc((yyleng+1)*sizeof(char));
	strncpy(yylval.string, yytext, yyleng + 1);
	return VAR_ID;
}

