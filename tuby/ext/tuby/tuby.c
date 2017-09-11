#include "tuby.h"
#include "buffer.h"
#include "obj_list.h"
#include "ibf_header.h"

VALUE rb_cTuby;
VALUE rb_cTubyParser;

static void tb_id_list_to_idx_list(long size, ObjList *obj_list, VALUE *ids_list, long *idx_list) {
  VALUE id;
  long idx;

  for (idx = 0; idx < size; idx++) {
    id = RARRAY_AREF(*ids_list, idx);
    idx_list[idx] = tb_obj_list_append(obj_list, &id);
  }
}

static VALUE tb_compile(VALUE self, VALUE content) {
  Buffer *buffer = tb_buffer_build();
  ObjList *obj_list = tb_obj_list_build();
  IBFHeader *header = tb_ibf_header_build();

  tb_buffer_append(buffer, header, sizeof(header));
  tb_buffer_append(buffer, RUBY_PLATFORM, strlen(RUBY_PLATFORM) + 1);

  VALUE iseq = rb_funcallv_public(rb_cTubyParser, rb_intern("compile"), 1, &content);
  VALUE ids_list = rb_funcall(iseq, rb_intern("ids_list"), 0, NULL);

  long id_idx_list_size = RARRAY_LEN(ids_list);
  long id_idx_list[id_idx_list_size];
  tb_id_list_to_idx_list(id_idx_list_size, obj_list, &ids_list, id_idx_list);

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
