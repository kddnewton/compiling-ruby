#ifndef TUBY_OBJ_LIST
#define TUBY_OBJ_LIST

#include <stdlib.h>
#include <ruby.h>

typedef struct tb_obj_list ObjList;

ObjList * tb_obj_list_build(void);
int tb_obj_list_append(ObjList *obj_list, VALUE *contents);
void tb_obj_list_destroy(ObjList *obj_list);

#endif
