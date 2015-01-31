callnim: callnim.o main.o system.o 
	clang callnim.o main.o system.o -o callnim

callnim.o system.o: callnim.nim
	nim c --noMain --noLinking --nimcache:. ./callnim.nim

main.o: main.c callnim.o
	clang -c main.c

clean:
	rm *.o callnim.c system.c
