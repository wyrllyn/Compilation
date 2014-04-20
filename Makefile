STD = -std=c99

all: prog

prog: compiler.tab.o lex.yy.o table.o utils.o
	gcc -o $@ $^ -lfl

compiler.tab.o: compiler.tab.c compiler.tab.h
	gcc -o $@ -c compiler.tab.c ${STD}

compiler.tab.c compiler.tab.h: compiler.y table.o utils.o
	bison compiler.y --defines=compiler.tab.h

lex.yy.o: lex.yy.c
	gcc -o $@ -c lex.yy.c

lex.yy.c: lex.l compiler.tab.h
	flex lex.l

table.o: table.h table.c
	gcc -o $@ -c table.c ${STD}

utils.o: utils.h utils.c table.o
	gcc -o $@ -c utils.c ${STD}

clean:
	rm *.o
	rm *.tab.c
	rm *.tab.h

run: all
	./prog test.pas
