#include "ibf_header.h"

#define ISEQ_MAJOR_VERSION 2
#define ISEQ_MINOR_VERSION 3

struct tb_ibf_header {
  char magic[4]; /* YARB */
  unsigned int major_version;
  unsigned int minor_version;
  unsigned int size;
  unsigned int extra_size;

  unsigned int iseq_list_size;
  unsigned int id_list_size;
  unsigned int object_list_size;

  tb_ibf_offset_t iseq_list_offset;
  tb_ibf_offset_t id_list_offset;
  tb_ibf_offset_t object_list_offset;
};

IBFHeader * tb_ibf_header_build(void) {
  IBFHeader *header = (IBFHeader *) malloc(sizeof(IBFHeader));

  memcpy(header->magic, "YARB", 4);
  header->major_version = ISEQ_MAJOR_VERSION;
  header->minor_version = ISEQ_MINOR_VERSION;

  header->size = 0;
  header->extra_size = 0;

  header->iseq_list_size = 0;
  header->id_list_size = 0;
  header->object_list_size = 0;

  header->iseq_list_offset = 0;
  header->id_list_offset = 0;
  header->object_list_offset = 1;

  return header;
}

void tb_ibf_header_destroy(IBFHeader *header) {
  free(header);
}
