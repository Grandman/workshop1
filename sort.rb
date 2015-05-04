module Calculator
  def self.calc(expressions)
    tokens = tokenizer expressions
    polish_array = polish tokens
    stack = []
    polish_array.each do |item|
      if item =~ /\d+/
          stack << item.to_i
      else
        result = stack[-2, 2].reduce(&item.to_sym)
        stack.pop 2
        stack << result
      end
    end
    stack.first
  end

  def self.tokenizer(expressions)
    expressions.gsub!(/\s+/,'')
    tokens = expressions.scan(/\d+|\+|\-|\*|\/|\(|\)/)
    return tokens if tokens.join == expressions
    nil
  end

  def self.polish(expressions)
    out = []
    stack = []
    prioritet = {
        '+' => 1,
        '-' => 1,
        '*' => 2,
        '/' => 2
    }
    expressions.each do |item|
      case item
        when /\d+/
          out.push item
        when /\+|\-|\*|\//
          op1 = item
          while(op2 = stack.last) && (op2 =~ /\+|\-|\*|\//) && prioritet[op1] <= prioritet[op2]
            stack.pop
            out.push op2
          end
          stack.push op1
        when '('
          stack.push item
        when ')'
          while(op = stack.last) && (op != '(')
              out.push op
              stack.pop
          end
          stack.pop if stack.last == '('
      end
    end
    stack.reverse.each do |op|
      out.push op
    end
    p out
  end
end
  p Calculator.calc '(1+3)/4+3'