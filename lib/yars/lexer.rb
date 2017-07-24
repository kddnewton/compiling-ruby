module Yars
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
        when /\A\s+/
        when /\A\d+/
          tokens << [:NUMBER, $&.to_i]
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
