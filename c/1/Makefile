
all : cat

cat : cat.o
	gcc cat.o -o cat

cat.o : cat.c
	gcc -c cat.c -o cat.o

clean :
	rm cat.o cat

.PHONY: clean

