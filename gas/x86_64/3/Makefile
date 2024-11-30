# SPDX-License-Identifier: GPL-3.0-or-later
#
# cat.s -- plain-cat(1) read from stdin and write to stdout
#
# Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)
#

all : cat

cat : cat.o
	ld cat.o -o cat

cat.o : cat.2.s
	gcc -Os -Wa,--64 -c cat.2.s -o cat.o

test :
	bash test.sh

clean :
	rm cat cat.o

sample : sample.o
	ld sample.o -o sample
sample.o : 4.s
	gcc -Os -Wa,--64 -c 4.s -o sample.o

.PHONY: clean

