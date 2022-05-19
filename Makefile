TARGET=calc
all: ${TARGET}

${TARGET}: ${TARGET}_parser.o ${TARGET}_lexer.o main.o
	g++ --std=c++11 -g -o $@ $^

main.o: main.cpp
	g++ --std=c++11 -g -c -o $@ $<

${TARGET}_lexer.o: ${TARGET}_lexer.cpp
	g++ --std=c++11 -g -c -o $@ $<

${TARGET}_lexer.cpp: ${TARGET}.l
	flex -o $@ $<

${TARGET}_parser.cpp: ${TARGET}.y
	bison --defines=tokens.h -o $@ $<

${TARGET}_parser.o: ${TARGET}_parser.cpp
	g++ --std=c++11 -g -c -o $@ $<

clean:
	rm -f *.o
	rm -f ${TARGET}_lexer.cpp
	rm -f ${TARGET}
	rm -f ${TARGET}_parser.cpp
	rm -f tokens.h
