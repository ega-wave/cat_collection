# SPDX-License-Identifier: GPL-3.0-or-later
# Makefile for plain-cat(1)
# 
# Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)

all : cat

cat : cat.o
	ld cat.o -o cat

cat.o : cat.s
	gcc -Os -Wa,--64 -c cat.s -o cat.o

test :
	bash test.sh

clean :
	rm cat cat.o

.PHONY: test clean

