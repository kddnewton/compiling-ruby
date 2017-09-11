module Tuby
  class InstructionSequence
    attr_reader :ids, :local, :calls, :insns

    def initialize
      @ids = Set.new([0])
      @local = Set.new
      @calls = []
    end

    def add_operator(operator)
      ids << operator
      calls << operator
    end

    def add_variable(variable)
      ids << variable
      local << variable
    end

    def scope=(scope)
      @insns = scope.compile
    end

    private

    def ids_list
      ids.to_a
    end
  end
end
