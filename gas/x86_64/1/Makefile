# SPDX-License-Identifier: GPL-3.0-or-later
# Makefile for plain-cat(1)
# 
# Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)

all : cat

cat : cat.s
	gcc -s -nostdlib -Wa,--64 cat.s -o cat

test :
	bash test.sh

clean :
	rm cat

.PHONY: test clean

