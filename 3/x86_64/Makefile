# SPDX-License-Identifier: GPL-3.0-or-later
#
# cat.s -- plain-cat(1) read from stdin and write to stdout
#
# Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)
#

all : cat.1

cat.1 : cat.1.gas
	gcc -s -nostdlib -Wa,--64 -x assembler cat.1.gas -o cat.1

test.1 :
	bash test.1.sh

clean :
	rm cat.1 

.PHONY: clean test.1

