#include "tuby.h"
#include "buffer.h"
#include "obj_list.h"
#include "ibf_header.h"

VALUE rb_cTuby;
VALUE rb_cTubyParser;

static VALUE tb_compile(VALUE self, VALUE content) {
  Buffer *buffer = tb_buffer_build();
  ObjList *obj_list = tb_obj_list_build();
  IBFHeader *header = tb_ibf_header_build();

  tb_buffer_append(buffer, header, sizeof(header));
  tb_buffer_append(buffer, RUBY_PLATFORM, strlen(RUBY_PLATFORM) + 1);

  VALUE iseq = rb_funcallv_public(rb_cTubyParser, rb_intern("compile"), 1, &content);
  tb_buffer_write(buffer, "output.yarb");

  tb_buffer_destroy(buffer);
  tb_obj_list_destroy(obj_list);
  tb_ibf_header_destroy(header);

  return iseq;
}

void Init_tuby() {
  VALUE rb_cRacc = rb_define_module("Racc");
  VALUE rb_cRaccParser = rb_define_class_under(rb_cRacc, "Parser", rb_cObject);

  rb_cTuby = rb_define_module("Tuby");
  rb_cTubyParser = rb_define_class_under(rb_cTuby, "Parser", rb_cRaccParser);
  rb_define_singleton_method(rb_cTuby, "compile", tb_compile, 1);
}
