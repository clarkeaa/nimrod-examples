callnimobj: callnimobj.o main.o system.o 
	clang -g callnimobj.o main.o system.o -o callnimobj -ldl

callnimobj.o system.o callnimobj.h: callnimobj.nim
	nim c --debugInfo --header:callnimobj.h --noMain --noLinking --nimcache:. ./callnimobj.nim

main.o: main.c callnimobj.h
	clang -g -c main.c -I/home/alice/dev/nim-0.10.2/lib/

clean:
	rm *.o callnimobj.c system.c callnimobj.h
