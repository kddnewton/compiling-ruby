module Extensions
  class RegexModifier
    attr_reader :pattern, :replacement

    def initialize(pattern, replacement)
      @pattern = pattern
      @replacement = replacement
    end

    def modify(source)
      source.gsub(pattern, replacement)
    end
  end
end
