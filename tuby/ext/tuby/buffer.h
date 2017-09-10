#ifndef TUBY_BUFFER
#define TUBY_BUFFER

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct tb_buffer Buffer;

Buffer * tb_buffer_build(void);
void tb_buffer_append(Buffer *buffer, const void *content, unsigned long size);
void tb_buffer_write(Buffer *buffer, const char *filepath);
void tb_buffer_destroy(Buffer *buffer);

#endif
