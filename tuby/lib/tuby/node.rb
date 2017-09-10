module Tuby
  module Node
    Assign = Struct.new(:ident, :expr) do
      def compile
        [*expr.compile, [:setlocal, ident.name]]
      end

      def exec(state)
        state, value = expr.exec(state)
        state[ident.name] = value
        [state, value]
      end
    end

    Binary = Struct.new(:left, :op, :right) do
      OPS = { '+' => :plus, '-' => :minus, '*' => :mult, '/' => :div }

      def compile
        [*left.compile, *right.compile, :"opt_#{OPS[op]}"]
      end

      def exec(state)
        state, left_value = left.exec(state)
        state, right_value = right.exec(state)
        [state, left_value.public_send(op, right_value)]
      end
    end

    Ident = Struct.new(:name) do
      def compile
        [[:getlocal, name]]
      end

      def exec(state)
        unless state.key?(name)
          raise NameError, "Cannot find local variable #{name} in scope"
        end
        [state, state[name]]
      end
    end

    Number = Struct.new(:value) do
      def compile
        [[:putobject, value]]
      end

      def exec(state)
        [state, value]
      end
    end

    class Scope
      attr_reader :statements

      def initialize(statement = nil)
        @statements = statement ? [statement] : []
      end

      def <<(statement)
        statements << statement
      end

      def compile
        statements.flat_map(&:compile)
      end

      def exec(state = {})
        response = nil

        statements.each do |statement|
          state, response = statement.exec(state)
        end

        response
      end
    end
  end
end
