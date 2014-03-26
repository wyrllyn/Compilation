all: prog

prog: compiler.tab.o lex.yy.o
	gcc -o $@ $^ -lfl

compiler.tab.o: compiler.tab.c compiler.tab.h
	gcc -o $@ -c compiler.tab.c

compiler.tab.c compiler.tab.h: compiler.y
	bison compiler.y --defines=compiler.tab.h

lex.yy.o: lex.yy.c
	gcc -o $@ -c lex.yy.c

lex.yy.c: lex.l compiler.tab.h
	flex lex.l

clean:
	rm *.o
	rm *.tab.c
	rm *.tab.h
