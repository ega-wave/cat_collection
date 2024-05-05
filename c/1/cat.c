/**
cat.s -- plain cat(1) read from stdin and write to stdout

Copyright (C) 2024 Yoshitaka Egawa.

This program is free software: you can redistribute it and/or 
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either 
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License 
along with this program.
If not, see <https://www.gnu.org/licenses/>.
**/

/* Written by Yoshitaka Egawa. */

/* plain-cat(1) - copy stdin to stdout */
/* using system call read(2)/write(2)  */

#include <unistd.h> // for read(), write()
#include <stdio.h>  // for fputs(), fprintf()
#include <stdlib.h> // for calloc()
#include <errno.h>  // for errno
#include <string.h> // for strerror()

const int BUF_SIZE = 128*1024;

int main()
{
  int count_read;
  int count_write;

  // initialize : create buffer
  void* buf = calloc(BUF_SIZE, 1);
  if (buf == NULL) {
    fputs(strerror(errno), stderr);
    exit(1);
  }

  while (1)
  { // read
    count_read = read(0, buf, BUF_SIZE);
    if ( count_read == 0 ) break;

    // write
    count_write = write(1, buf, count_read);
    if (count_write != count_read)
    {
      fprintf(stderr, "plain-cat : write error : read=%d, write=%d\n", count_read, count_write);
      exit(1);
    }
  }

  return 0;
}

