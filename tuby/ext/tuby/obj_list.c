#include "obj_list.h"

typedef struct tb_obj_list_entry {
  VALUE *contents;
  struct tb_obj_list_entry *next;
} ObjListEntry;

struct tb_obj_list {
  int size;
  ObjListEntry *head;
  ObjListEntry *tail;
};

static ObjListEntry * tb_obj_list_entry_build(VALUE *contents) {
  ObjListEntry *entry = (ObjListEntry *) malloc(sizeof(ObjListEntry));
  entry->contents = contents;
  entry->next = NULL;
  return entry;
}

static void tb_obj_list_entry_destroy(ObjListEntry *entry) {
  free(entry);
}

ObjList * tb_obj_list_build(void) {
  ObjList *list = (ObjList *) malloc(sizeof(ObjList));
  list->size = 0;
  list->head = NULL;
  list->tail = NULL;
  return list;
}

int tb_obj_list_append(ObjList *list, VALUE *contents) {
  list->size++;
  ObjListEntry *next = tb_obj_list_entry_build(contents);

  if (list->head) {
    list->tail->next = next;
    list->tail = next;
  } else {
    list->head = next;
    list->tail = next;
  }
  return list->size - 1;
}

void tb_obj_list_destroy(ObjList *list) {
  ObjListEntry *previous = list->head;
  ObjListEntry *current = list->head;

  while (previous != NULL) {
    current = current->next;
    tb_obj_list_entry_destroy(previous);
    previous = current;
  }

  free(list);
}
