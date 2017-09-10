#ifndef TUBY_IBF_HEADER
#define TUBY_IBF_HEADER

#include <stdlib.h>
#include <string.h>

typedef struct tb_ibf_header IBFHeader;
typedef unsigned int tb_ibf_offset_t;

IBFHeader * tb_ibf_header_build(void);
void tb_ibf_header_destroy(IBFHeader *header);

#endif
