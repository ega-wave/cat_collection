/* SPDX-License-Identifier: GPL-3.0-or-later */
/*
 * cat.c -- plain-cat(1) read from stdin and write to stdout
 *
 * Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)
 */

/* plain-cat(1) - copy stdin to stdout */
/* using system call read(2)/write(2)  */

#include <unistd.h> // for read(), write()
#include <stdio.h>  // for fputs(), fprintf()

#define BUF_SIZE (128*1024)
char buf[BUF_SIZE];

int main()
{
  int count_read;
  int count_write;

  while (1)
  { // read
    count_read = read(0, buf, BUF_SIZE);
    if ( count_read == 0 ) break;

    // write
    count_write = write(1, buf, count_read);
    if (count_write != count_read)
    {
      fprintf(stderr, "plain-cat : write error : read=%d, write=%d\n", count_read, count_write);
      return 1;
    }
  }

  return 0;
}

