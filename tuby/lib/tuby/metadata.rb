module Tuby
  class Metadata
    ARGS_SIMPLE = 16
    CallInfo = Struct.new(:mid, :flag, :argc)

    attr_reader :id_table_keys, :local_table_keys, :call_info_list

    def initialize
      @id_table_keys = Set.new
      @local_table_keys = Set.new
      @call_info_list = []
    end

    def add_op(op)
      @id_table_keys << op
      @call_info_list << CallInfo.new(op, ARGS_SIMPLE, 1)
    end

    def add_var(var)
      @id_table_keys << var
      @local_table_keys << var
    end

    def to_s
      str = "--- metadata ---\nid table keys (#{id_table_keys.size}) ->\n  "
      str << id_table_keys.to_a.join("\n  ")
      str << "\nlocal table keys (#{local_table_keys.size}) ->\n  "
      str << local_table_keys.to_a.join("\n  ")
      str << "\ncall info list (#{call_info_list.size})->\n  "
      str << call_info_list.join("\n  ")
      str << "\n--- metadata ---\n"
    end
  end
end
