module Tuby
  class Insn
    attr_reader :lineno, :type, :values

    def initialize(lineno, type, *values)
      @lineno = lineno
      @type = type
      @values = values
    end
  end
end
