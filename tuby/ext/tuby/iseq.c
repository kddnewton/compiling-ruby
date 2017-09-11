#include "iseq.h"

typedef struct tb_iseq_location_struct {
  VALUE pathobj;      /* String (path) or Array [path, realpath]. Frozen. */
  VALUE base_label;   /* String */
  VALUE label;        /* String */
  VALUE first_lineno; /* TODO: may be unsigned short */
} tb_iseq_location_t;

tb_iseq_location_t * tb_iseq_location_build(const char *filename) {
  VALUE label = rb_str_new_cstr("<main>");
  VALUE compiled = Qtrue;
  VALUE pathobj = rb_ary_new3(2, rb_str_new_cstr(filename), &compiled);

  tb_iseq_location_t *location = (tb_iseq_location_t *) malloc(sizeof(tb_iseq_location_t));
  location->pathobj = pathobj;
  location->base_label = label;
  location->label = label;
  location->first_lineno = INT2FIX(1);

  return location;
}

typedef struct tb_iseq_constant_body {
  enum iseq_type {
    ISEQ_TYPE_TOP,
    ISEQ_TYPE_METHOD,
    ISEQ_TYPE_BLOCK,
    ISEQ_TYPE_CLASS,
    ISEQ_TYPE_RESCUE,
    ISEQ_TYPE_ENSURE,
    ISEQ_TYPE_EVAL,
    ISEQ_TYPE_MAIN,
    ISEQ_TYPE_DEFINED_GUARD
  } type;              /* instruction sequence type */
} tb_iseq_constant_body_t;

tb_iseq_constant_body_t * tb_iseq_constant_body_build(void) {
  tb_iseq_constant_body_t *body = (tb_iseq_constant_body_t *) malloc(sizeof(tb_iseq_constant_body_t));
  body->type = ISEQ_TYPE_TOP;
  return body;
}

//   unsigned int iseq_size;
//   const VALUE *iseq_encoded; /* encoded iseq (insn addr and operands) */
//
//   /**
//    * parameter information
//    *
//    *  def m(a1, a2, ..., aM,                    # mandatory
//    *        b1=(...), b2=(...), ..., bN=(...),  # optional
//    *        *c,                                 # rest
//    *        d1, d2, ..., dO,                    # post
//    *        e1:(...), e2:(...), ..., eK:(...),  # keyword
//    *        **f,                                # keyword_rest
//    *        &g)                                 # block
//    * =>
//    *
//    *  lead_num     = M
//    *  opt_num      = N
//    *  rest_start   = M+N
//    *  post_start   = M+N+(*1)
//    *  post_num     = O
//    *  keyword_num  = K
//    *  block_start  = M+N+(*1)+O+K
//    *  keyword_bits = M+N+(*1)+O+K+(&1)
//    *  size         = M+N+O+(*1)+K+(&1)+(**1) // parameter size.
//    */
//
//   struct {
//     struct {
//       unsigned int has_lead   : 1;
//       unsigned int has_opt    : 1;
//       unsigned int has_rest   : 1;
//       unsigned int has_post   : 1;
//       unsigned int has_kw     : 1;
//       unsigned int has_kwrest : 1;
//       unsigned int has_block  : 1;
//       unsigned int ambiguous_param0 : 1; /* {|a|} */
//     } flags;
//
//     unsigned int size;
//
//     int lead_num;
//     int opt_num;
//     int rest_start;
//     int post_start;
//     int post_num;
//     int block_start;
//
//     const VALUE *opt_table; /* (opt_num + 1) entries. */
//     /* opt_num and opt_table:
//      *
//      * def foo o1=e1, o2=e2, ..., oN=eN
//      * #=>
//      *   # prologue code
//      *   A1: e1
//      *   A2: e2
//      *   ...
//      *   AN: eN
//      *   AL: body
//      * opt_num = N
//      * opt_table = [A1, A2, ..., AN, AL]
//      */
//
//     const struct rb_iseq_param_keyword {
//       int num;
//       int required_num;
//       int bits_start;
//       int rest_start;
//       const ID *table;
//       const VALUE *default_values;
//     } *keyword;
//   } param;
//
//   tb_iseq_location_t location;
//
//   /* insn info, must be freed */
//   const struct iseq_line_info_entry *line_info_table;
//
//   const ID *local_table;    /* must free */
//
//   /* catch table */
//   const struct iseq_catch_table *catch_table;
//
//   /* for child iseq */
//   const struct rb_iseq_struct *parent_iseq;
//   struct rb_iseq_struct *local_iseq; /* local_iseq->flip_cnt can be modified */
//
//   union iseq_inline_storage_entry *is_entries;
//   struct rb_call_info *ci_entries; /* struct rb_call_info ci_entries[ci_size];
//             * struct rb_call_info_with_kwarg cikw_entries[ci_kw_size];
//             * So that:
//             * struct rb_call_info_with_kwarg *cikw_entries = &body->ci_entries[ci_size];
//             */
//   struct rb_call_cache *cc_entries; /* size is ci_size = ci_kw_size */
//
//   VALUE mark_ary;     /* Array: includes operands which should be GC marked */
//
//   unsigned int local_table_size;
//   unsigned int is_size;
//   unsigned int ci_size;
//   unsigned int ci_kw_size;
//   unsigned int line_info_size;
//   unsigned int stack_max; /* for stack overflow check */
// };
