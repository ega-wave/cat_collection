/* SPDX-License-Identifier: GPL-3.0-or-later */
/*
 * Makefile -- for plain-cat(1)
 *
 * Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)
 */

all : cat

cat : cat.o
	gcc cat.o -o cat

cat.o : cat.c
	gcc -c cat.c -o cat.o

clean :
	rm cat.o cat

.PHONY: clean

