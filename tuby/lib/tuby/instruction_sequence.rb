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
      @insns = inject_traces_to(scope.compile)
    end

    private

    def ids_list
      ids.to_a
    end

    def inject_traces_to(insns)
      lineno = 0
      insns.each_with_object([]) do |insn, full|
        if lineno != insn.lineno
          lineno = insn.lineno
          full << Insn.new(lineno, :trace, 1)
        end
        full << insn
      end
    end
  end
end
