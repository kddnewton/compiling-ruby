class Tuby::Parser
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: scope

  assign: identifier '=' expr     { result = Node::Assign.new(val[0], val[2]) }

  expr: expr '+' expr             { metadata.add_op(:"+"); result = Node::Binary.new(*val[0..2]) }
      | expr '-' expr             { metadata.add_op(:"-"); result = Node::Binary.new(*val[0..2]) }
      | expr '*' expr             { metadata.add_op(:"*"); result = Node::Binary.new(*val[0..2]) }
      | expr '/' expr             { metadata.add_op(:"/"); result = Node::Binary.new(*val[0..2]) }
      | '(' expr ')'              { result = val[1] }
      | number
      | identifier

  number: '-' NUMBER  =UMINUS     { result = Node::Number.new(-val[1]) }
        | NUMBER                  { result = Node::Number.new(val[0]) }

  identifier: IDENT               { metadata.add_var(val[0])
                                    result = Node::Ident.new(val[0]) }

  scope: statement                { result = Node::Scope.new(val[0]) }
       | scope stmt_end statement { val[0] << val[2]; result = val[0] }
       | /* none */               { result = Node::Scope.new }

  statement: assign | expr

  stmt_end: NEWLINE | ';'
end

---- inner
  include Tuby
  attr_reader :lexer, :metadata

  def parse(input)
    @lexer = Lexer.new(input)
    @metadata = Metadata.new
    result = do_parse
    puts metadata
    result
  end

  def self.parse(input)
    new.parse(input)
  end

  def next_token
    lexer.next_token
  end
