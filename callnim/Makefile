callnim: callnim.o main.o stdlib_system.o 
	clang callnim.o main.o stdlib_system.o -o callnim

callnim.o stdlib_system.o: callnim.nim
	nimrod c --noMain --noLinking --nimcache:. ./callnim.nim

main.o: main.c callnim.o
	clang -c main.c

clean:
	rm *.o callnim.c stdlib_system.c
