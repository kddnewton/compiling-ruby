Extensions.configure do |config|
  # Add date sigils
  config.add Extensions::RegexModifier.new(/~d\((.+?)\)/, 'Date.parse("\1")')

  # Add URI sigils
  config.add Extensions::RegexModifier.new(/~u\((.+?)\)/, 'URI.parse("\1")')

  # Add numeric sigils that pre-compute their value
  config.add(
    Extensions::RegexModifier.new(/~n\(([\d\s+-\/*\(\)]+?)\)/) do |match|
      eval(match[3..-2])
    end)

  # Add type-safe checking on method arguments
  config.add(
    Extensions::ASTModifier.new do |modifier|
      modifier.extend_parser(:arg, 'arg tCOLON cname') do
        @lexer.state = :expr_endarg
        result = @builder.type_check(val[0], val[2])
      end

      modifier.extend_builder(:type_check) do |arg, cname|
        arg << n(:tcheck, [cname], arg.loc)
      end
    end)
end
