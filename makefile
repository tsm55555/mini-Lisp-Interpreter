CC := g++

yacc     := final.y
parser_c := final.tab.cc
parser_h := final.tab.hh
parser_o := final.tab.o

lex := final.l
scanner_c := final.yy.cc
scanner_o := final.yy.o

exec := final
test_data = ./testcase/test_data

all: $(exec)

$(parser_o):
	bison -d -o $(parser_c) $(yacc)
	$(CC) -c -g -I .. -o $(parser_o) $(parser_c)

$(scanner_o): $(parser_o)
	flex -o $(scanner_c) $(lex)
	$(CC) -c -g -I .. -o $(scanner_o) $(scanner_c)

$(exec): $(scanner_o) $(parser_o)
	$(CC) -o $(exec) $(scanner_o) $(parser_o) -ll
	-rm $(parser_c)
	-rm $(scanner_c)
	-rm $(parser_h)
	-rm $(parser_o)
	-rm $(scanner_o)

clean:
	-rm $(exec)
	-rm ./testcase/output/*

test: $(exec)
	./final < ./testcase/test_data/01_1.lsp > ./testcase/output/01_1.out
	./final < ./testcase/test_data/01_2.lsp > ./testcase/output/01_2.out
	./final < ./testcase/test_data/02_1.lsp > ./testcase/output/02_1.out
	./final < ./testcase/test_data/02_2.lsp > ./testcase/output/02_2.out
	./final < ./testcase/test_data/03_1.lsp > ./testcase/output/03_1.out
	./final < ./testcase/test_data/03_2.lsp > ./testcase/output/03_2.out
	./final < ./testcase/test_data/04_1.lsp > ./testcase/output/04_1.out
	./final < ./testcase/test_data/04_2.lsp > ./testcase/output/04_2.out
	./final < ./testcase/test_data/05_1.lsp > ./testcase/output/05_1.out
	./final < ./testcase/test_data/05_2.lsp > ./testcase/output/05_2.out
	./final < ./testcase/test_data/06_1.lsp > ./testcase/output/06_1.out
	./final < ./testcase/test_data/06_2.lsp > ./testcase/output/06_2.out
	./final < ./testcase/test_data/07_1.lsp > ./testcase/output/07_1.out
	./final < ./testcase/test_data/07_2.lsp > ./testcase/output/07_2.out
	./final < ./testcase/test_data/08_1.lsp > ./testcase/output/08_1.out
	./final < ./testcase/test_data/08_2.lsp > ./testcase/output/08_2.out
	
