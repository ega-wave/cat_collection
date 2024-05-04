
all : cat

cat : cat.o
	ld cat.o -o cat

cat.o : cat.s
	gcc -Os -Wa,--64 -c cat.s -o cat.o

clean :
	rm cat cat.o

.PHONY: clean

