module Tuby
  class InstructionSequence
    attr_reader :ids, :local, :calls

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
  end
end
