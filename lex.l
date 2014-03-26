%{
#include <stdio.h>
#include <string.h>

extern int yyparse();

%}

CHIFFRE[0-9]
LETTRE[a-zA-Z]
%x COMMENTAIRE
%x INF
%x SUP
%X DP

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

"div"|"mod"|"var"|"integer"|"real"|"char"|"boolean"|"if"|"then"|"else"|"while"|"do"|"readln"|"writeln"|"function"|"procedure"|"program" {
	return yytext;
}


"{" {
	BEGIN(COMMENTAIRE);
}

<COMMENTAIRE>.|"\n" {
}

<COMMENTAIRE><<EOF>> {
	printf("commentaire non terminé\n");
}

<COMMENTAIRE>"}" {
	BEGIN(INITIAL);
}

"<" {
	BEGIN(INF);
}

<INF>"="|">" {
	return strcat("<", yytext[0]);
	BEGIN(INITIAL);
}

<INF>^[=>] {
	return "<";
	BEGIN(INITIAL);
}

">" {
	BEGIN(SUP);
}

<SUP>"=" {
	return strcat(">", yytext[0]);
	BEGIN(INITIAL);
}

<SUP>^[=] {
	return ">";
	BEGIN(INITIAL);
}

":" {
	BEGIN(DP);
}

<DP>"=" {
	return strcat(":", yytext[0]);
	BEGIN(INITIAL);
}

<DP>^[=] {
	return ":";
	BEGIN(INITIAL);
}

"=" {
	return yytext[0];
}

LETTRE+(CHIFFRE*LETTRE*)* {
	return yytext;
}
