module Extensions
  module Modifiers
    class DateSigil < RegexModifier
      def initialize
        super(/~d\((.+?)\)/, 'Date.parse("\1")')
      end
    end
  end
end
