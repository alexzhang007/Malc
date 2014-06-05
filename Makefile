malc:  main.c y.tab.o symtab.o misc.o init.o codegen.o gvars.h
	gcc main.c *.o -ly -ll -o malc

symtab.o: symtab.c gvars.h
	gcc symtab.c -c

init.o: init.c gvars.h
	gcc init.c -c

misc.o: misc.c gvars.h
	gcc misc.c -c

codegen.o: codegen.c gvars.h
	gcc codegen.c -c

y.tab.o: y.tab.c lex.yy.c gvars.h
	gcc y.tab.c -c

y.tab.c: malc.yacc
	yacc malc.yacc

lex.yy.c: malc.lex
	lex malc.lex

clean:
	rm *.o
	rm y.tab.c
	rm lex.yy.c

