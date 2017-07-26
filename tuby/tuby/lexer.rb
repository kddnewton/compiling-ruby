module Tuby
  class Lexer
    attr_reader :tokens

    def initialize(input)
      @tokens = []
      parse(input)
    end

    def next_token
      tokens.shift
    end

    private

    def parse(input)
      until input.empty?
        case input
        when /\A\n/
          tokens << [:NEWLINE, "\n"]
        when /\A\s+/
        when /\A\d+/
          tokens << [:NUMBER, $&.to_i]
        when /\A[a-z]([A-Za-z0-9_]+)?/
          tokens << [:IDENT, $&]
        when /\A.|\n/o
          symbol = $&
          tokens << [symbol, symbol]
        end
        input = $'
      end
      tokens.push [false, '$end']
    end
  end
end
