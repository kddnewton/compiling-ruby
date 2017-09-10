#ifndef TUBY_BUFFER
#define TUBY_BUFFER

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct buffer Buffer;

Buffer * buffer_build(void);
void buffer_append(Buffer *buffer, const void *content, unsigned long size);
void buffer_write(Buffer *buffer, const char *filepath);
void buffer_destroy(Buffer *buffer);

#endif
