module Extensions
  class ASTModifier
    BuilderExtension = Struct.new(:method, :block)
    attr_reader :builder_extensions

    ParserExtension = Struct.new(:symbol, :pattern, :code)
    attr_reader :parser_extensions

    def initialize
      @builder_extensions = []
      @parser_extensions = []
      yield self
    end

    def extend_builder(method, &block)
      builder_extensions << BuilderExtension.new(method, block)
    end

    def extend_parser(symbol, pattern, &block)
      filepath, lineno = block.source_location
      code = File.readlines(filepath)[lineno..-1].take_while { |line| line.strip != 'end' }.join
      parser_extensions << ParserExtension.new(symbol, pattern, code)
    end

    def modify(source)
      source
    end
  end
end
