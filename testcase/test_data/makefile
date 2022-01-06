YACC:=final.tab.o
LEX:=final.yy.o
EXEC:=final

all: $(EXEC)

$(YACC):
	bison -d -o final.tab.c final.y
	gcc -c -g -I .. final.tab.c

$(LEX): $(YACC)
	flex -o final.yy.c final.l
	gcc -c -g -I .. final.yy.c

$(EXEC): $(LEX) $(YACC)
	gcc -o final final.tab.o final.yy.o -ll
	rm final.tab.c
	rm final.tab.h
	rm final.tab.o
	rm final.yy.c
	rm final.yy.o


clean:
	rm final