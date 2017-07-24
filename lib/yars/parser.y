class Yars::Parser
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
rule
  target: expr
        | /* none */        { result = 0 }

  expr: expr '+' expr       { result = Node::Expr.new(*val[0..2]) }
      | expr '-' expr       { result = Node::Expr.new(*val[0..2]) }
      | expr '*' expr       { result = Node::Expr.new(*val[0..2]) }
      | expr '/' expr       { result = Node::Expr.new(*val[0..2]) }
      | '(' expr ')'        { result = val[1] }
      | '-' NUMBER  =UMINUS { result = Node::Number.new(-val[1]) }
      | NUMBER              { result = Node::Number.new(val[0]) }
end

---- inner
  include Yars
  attr_reader :lexer

  def parse(input)
    @lexer = Lexer.new(input)
    do_parse
  end

  def next_token
    lexer.next_token
  end
