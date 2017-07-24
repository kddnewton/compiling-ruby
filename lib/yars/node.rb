module Yars
  module Node
    Number = Struct.new(:value) do
      def compile(insns)
        insns << [:put_object, value]
      end

      def exec
        value
      end
    end

    Expr = Struct.new(:left, :op, :right) do
      OPS = { '+' => :plus, '-' => :minus, '*' => :mult, '/' => :div }

      def compile(insns)
        left.compile(insns)
        right.compile(insns)
        insns << [:"opt_#{OPS[op]}"]
      end

      def exec
        left.compile.public_send(op, right.compile)
      end
    end
  end
end
