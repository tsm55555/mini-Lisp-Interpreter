CC := g++

yacc     := final.y
parser_c := final.tab.cc
parser_h := final.tab.hh
parser_o := final.tab.o

lex := final.l
scanner_c := final.yy.cc
scanner_o := final.yy.o

exec := ./final
test_data = ./testcase/test_data/*.lsp
hidden_test_data = ./testcase/hidden1/*.lsp
hidden_test_data2 = ./testcase/hidden2/*.lsp

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
	-clear 
clean:
	#-rm ./testcase/output/*
	#-rm ./testcase/test_data/*.out
	#-rm ./testcase/hidden1/*.out
	#-rm ./testcase/hidden2/*.out
	-rm $(parser_c)
	-rm $(scanner_c)
	-rm $(parser_h)
	-rm $(parser_o)
	-rm $(scanner_o)
	-rm $(exec)
	-clear

test: $(test_data) $(hidden_test_data) $(hidden_test_data2)
	@for f in $(test_data); do ./final < $${f} > $${f}.out; done
	@for f in $(hidden_test_data); do ./final < $${f} > $${f}.out; done
	@for f in $(hidden_test_data2); do ./final < $${f} > $${f}.out; done
	-mv ./testcase/test_data/*.out ./testcase/output/
	#-mv ./testcase/hidden1/*.out ./testcase/output/
	-clear
