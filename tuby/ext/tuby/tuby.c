#include "tuby.h"
#include "buffer.h"
#include "ibf_header.h"

static VALUE tb_compile(VALUE self, VALUE content) {
  IBFHeader *header = tb_ibf_header_build();
  Buffer *buffer = tb_buffer_build();

  tb_buffer_append(buffer, header, sizeof(header));
  tb_buffer_append(buffer, RUBY_PLATFORM, strlen(RUBY_PLATFORM) + 1);

  tb_buffer_write(buffer, "output.yarb");
  tb_buffer_destroy(buffer);
  tb_ibf_header_destroy(header);

  return Qnil;
}

void Init_tuby()
{
  VALUE Tuby = rb_define_module("Tuby");
  rb_define_singleton_method(Tuby, "compile", tb_compile, 1);
}
