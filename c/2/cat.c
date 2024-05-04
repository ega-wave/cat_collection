
// plain-cat(1) - copy stdin to stdout

#include <stdio.h>  // for fputs(), fprintf(), fread(), fwrite()
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
    count_read = fread(buf, 1, BUF_SIZE, stdin);
    if ( count_read == 0 ) break;

    // write
    count_write = fwrite(buf, 1, count_read, stdout);
    if (count_write != count_read)
    {
      fprintf(stderr, "plain-cat : write error : read=%d, write=%d\n", count_read, count_write);
      exit(1);
    }
  }

  return 0;
}
