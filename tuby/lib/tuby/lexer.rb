module Tuby
  class Lexer
    attr_reader :text, :lineno, :newline

    def initialize(text)
      @text = text
      @lineno = 1
      @newline = false
    end

    def next_token
      if newline
        @lineno += 1
        @newline = false
      end
      pair = nil

      until pair
        case text
        when ''
          pair = [false, '$end']
        when /\A\n/
          @newline = true
          pair = [:NEWLINE, "\n"]
        when /\A\s+/
        when /\A\d+/
          pair = [:NUMBER, $&.to_i]
        when /\A[a-z]([A-Za-z0-9_]+)?/
          pair = [:IDENT, $&]
        when /\A./o
          pair = [$&, $&]
        end
        @text = $'
      end

      pair
    end
  end
end
