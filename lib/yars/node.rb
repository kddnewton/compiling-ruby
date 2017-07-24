module Yars
  module Node
    Literal = Struct.new(:value)
    MathOp = Struct.new(:left, :op, :right)
  end
end
