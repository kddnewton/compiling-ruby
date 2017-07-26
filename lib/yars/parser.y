class Yars::Parser
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: scope

  assign: identifier '=' expr { result = Node::Assign.new(val[0], val[2]) }

  expr: expr '+' expr         { result = Node::Binary.new(*val[0..2]) }
      | expr '-' expr         { result = Node::Binary.new(*val[0..2]) }
      | expr '*' expr         { result = Node::Binary.new(*val[0..2]) }
      | expr '/' expr         { result = Node::Binary.new(*val[0..2]) }
      | '(' expr ')'          { result = val[1] }
      | number
      | identifier

  number: '-' NUMBER  =UMINUS { result = Node::Number.new(-val[1]) }
        | NUMBER              { result = Node::Number.new(val[0]) }

  identifier: IDENT           { result = Node::Ident.new(val[0]) }

  scope: statement                { result = Node::Scope.new(val[0]) }
       | scope stmt_end statement { val[0] << val[2]; result = val[0] }
       | /* none */               { result = Node::Scope.new }

  statement: assign | expr

  stmt_end: NEWLINE | ';'
end

---- inner
  include Yars
  attr_reader :lexer

  def parse(input)
    @lexer = Lexer.new(input)
    do_parse
  end

  def self.parse(input)
    new.parse(input)
  end

  def next_token
    lexer.next_token
  end
