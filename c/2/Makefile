# cat.s -- plain cat(1) read from stdin and write to stdout
# 
# Copyright (C) 2024 Yoshitaka Egawa.
# 
# This program is free software: you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either 
# version 3 of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with this program.
# If not, see <https://www.gnu.org/licenses/>.

# Written by Yoshitaka Egawa.

all : cat

cat : cat.o
	gcc cat.o -o cat

cat.o : cat.c
	gcc -c cat.c -o cat.o

clean :
	rm cat.o cat

.PHONY: clean

