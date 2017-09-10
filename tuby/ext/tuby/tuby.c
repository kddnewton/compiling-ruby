#include "tuby.h"
#include "buffer.h"

#define ISEQ_MAJOR_VERSION 2
#define ISEQ_MINOR_VERSION 3

typedef unsigned int ibf_offset_t;

struct ibf_header {
  char magic[4]; /* YARB */
  unsigned int major_version;
  unsigned int minor_version;
  unsigned int size;
  unsigned int extra_size;

  unsigned int iseq_list_size;
  unsigned int id_list_size;
  unsigned int object_list_size;

  ibf_offset_t iseq_list_offset;
  ibf_offset_t id_list_offset;
  ibf_offset_t object_list_offset;
};

VALUE tb_compile(VALUE self, VALUE content) {
  struct ibf_header *header = (struct ibf_header *) malloc(sizeof(struct ibf_header));
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

  Buffer *buffer = buffer_build();
  buffer_append(buffer, header, sizeof(header));
  buffer_append(buffer, RUBY_PLATFORM, strlen(RUBY_PLATFORM) + 1);
  buffer_write(buffer, "output.yarb");
  buffer_destroy(buffer);

  free(header);

  return Qnil;
}

void Init_tuby()
{
  VALUE Tuby = rb_define_module("Tuby");
  rb_define_singleton_method(Tuby, "compile", tb_compile, 1);
}
