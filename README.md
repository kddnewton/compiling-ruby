# Compiling Ruby

Since `Ruby 2.3` we've been able to programmatically load ruby bytecode through the introduction of `RubyVM::InstructionSequence::load_iseq`. If the `::load_iseq` method is defined, every file that is required will pass through it. If `::load_iseq` then returns `nil`, the normal process of parsing the `Ruby` file will still happen. Otherwise, it should return a precompiled set of `Ruby` instructions through an instance of `RubyVM::InstructionSequence`. To read more about the initial proposal for this feature, see [the ruby issue](https://bugs.ruby-lang.org/issues/11788).

By divorcing the process of running `YARV` bytecode from the process of compiling `Ruby` code, `Ruby` can improve boot speed (because the `Ruby` source no longer has to be parsed into instruction sequences) and also reduce memory consumption on boot. These were both of the stated goals of `::load_iseq`, and it is accomplished and demonstrated in both the [`yomikomu`](https://github.com/ko1/yomikomu) and [`bootsnap`](https://github.com/Shopify/bootsnap) community gems.

For an example, let's take a look at a simple implementation of `::load_iseq`:

```ruby
class RubyVM::InstructionSequence
  ISEQ_DIR = File.expand_path(__dir__, '.iseq')

  def self.load_iseq(source_path)
    iseq_name = source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
                           .gsub('.rb', '.yarb'))
    iseq_path = File.join(ISEQ_DIR, iseq_name)

    if File.exist?(iseq_path) && (File.mtime(source_path) <= File.mtime(iseq_path))
      return RubyVM::InstructionSequence.load_from_binary(File.binread(iseq_path))
    end

    begin
      contents = File.read(source_path)
      iseq = RubyVM::InstructionSequence.compile(contents)
      File.binwrite(iseq_path, iseq.to_binary)
      iseq
    rescue SyntaxError, RuntimeError
      nil
    end
  end
end
```

For the above implementation, when `::load_iseq` is called, it will check to determine whether or not a compiled instruction sequence file has already been created for the given source file. If it has, and it's up to date with the latest source, it will return the compiled instruction sequence. If it is not, it will go through the process of compiling the source into bytecode, write that out for future runs, and then return the generated instruction sequences.

## Preprocessors

The above implementation works well and accomplishes the stated goals of the issue. However, there are other possibilities that this new functionality has enabled. After the source is read but before it is compiled, the contents can be preprocessed in any way you want.

### Modifying as text

As an example, we can modify the text in place without knowledge of the lexical context, as in Elixir-like sigils:

```ruby
contents = File.read(source_path)

# implement date sigils
format = '%FT%T%:z'
contents.gsub!(/~d\((.+?)\)/) do |match|
  content = match[3..-2]
  begin
    date = Date.parse(content)
    "Date.strptime('#{date.strftime(format)}', '#{format}')"
  rescue ArgumentError
    "Date.parse(#{content})"
  end
end

# implement number sigils
contents.gsub!(%r{~n\(([\d\s+-/*\(\)]+?)\)}) { |match| eval(match[3..-2]) }

# implement URI sigils
contents.gsub!(/~u\((.+?)\)/, 'URI.parse("\1")')

iseq = RubyVM::InstructionSequence.compile(contents)
```

This allows us clearly express date, numbers, and URIs within our code. It also has a couple of other benefits:

* for literal dates in the date sigil, it allows the `~d(January 1st, 2017)` format. This would normally be inefficiently parsed with `Date::parse`, but because of preprocessing actually gets parsed using the much more efficient `Date::strptime`
* for number sigils, the entire contents of the sigil is evaluated before the code is compiled. This means less memory being allocated and fewer instructions being sent to the VM. For example, usually `24 * 60 * 60` would require two function calls and three stack-allocated numbers. With a sigil (`~n(24 * 60 * 60)`) it's just one stack-allocated number and no function calls.

### Modifying as an AST

The other modification we can perform is after the text has been parsed into an abstract syntax tree (and we therefore have lexical context). For example, we can use the `parser` gem to build our own AST that contains invalid `Ruby`, rewrite it to a valid `Ruby` AST, and continue on, as in:

```ruby
content = File.read(source_path)

require 'parser/current'

# class CustomBuilder < Parser::Builders::Default
builder  = CustomBuilder.new

# class CustomParser < Parser::CurrentRuby
parser   = CustomParser.new(builder)

# class CustomRewriter < Parser::Rewriter
rewriter = CustomRewriter.new
rewriter.instance_variable_set(:@parser, parser)

buffer = Parser::Base.send(:setup_source_buffer, '(string)', 1,
                           content, parser.default_encoding)
ast = parser.parse(content)
content = rewriter.rewrite(buffer, ast)

iseq = RubyVM::InstructionSequence.compile(content)
```

### Vernacular

All of these modifications and more are encompassed by the [`vernacular`](vernacular) gem, included in this repository.
