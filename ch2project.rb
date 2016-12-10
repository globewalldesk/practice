=begin
This is a calculator project!
It does the four basic operations.
It inputs the first number, the operator, and the second number.
These are three instance variables for the user's object, viz., an object of the Problem class.
Depending on the operation, the class performs one of four methods on the first and second number,
and then spits out the answer.
=end

# Classes
class Problem
  attr_writer :firstarg
  attr_writer :op
  attr_writer :secondarg
  def calculate
    @answer = ""
    case @op
      when "+" then @answer = @firstarg.to_f + @secondarg.to_f
      when "-" then @answer = @firstarg.to_f - @secondarg.to_f
      when "*" then @answer = @firstarg.to_f * @secondarg.to_f
      when "/" then @answer = @firstarg.to_f / @secondarg.to_f
    end
    return @answer
  end

  def formatme
    if @answer == @answer.to_i
      format("%.0f",@answer)
    else
      @answer
    end
  end

end

# Methods
def valid (value)
  if (value == value.to_i.to_s) || (value == value.to_f.to_s)
    return 1
  else
    puts "Must be a number."
  end
end

def valid_operator (value)
  if value == "+" || value == "-" || value == "*" || value == "/"
    return 1
  else
    puts "Must be + - * / \nPlease choose one."
  end
end

puts "Welcome to the basic calculator!"
puts "We can do +, -, * and / and that's all."

stop = 0

# Basic loop cycles until canceled by user (when stop == 1)
until stop == 1 do

  # Clear any old values
  num1 = ""
  num2 = ""
  operator = ""

  # Cycle until you get a valid first number
  num1valid = 0
  until num1valid == 1
    puts "Enter first number: "
    num1 = gets.chomp
    num1valid = 1 if valid(num1)
  end

  operator_valid = 0
  until operator_valid == 1
    puts "Enter +, -, *, or /"
    operator = gets.chomp
    operator_valid = 1 if valid_operator(operator)
  end

  # Cycle until you get a valid second number
  num2valid = 0
  until num2valid == 1
    puts "Enter second number: "
    num2 = gets.chomp
    num2valid = 1 if valid(num2)
  end

  # Calculate answer
  problem = Problem.new
  problem.firstarg = num1
  problem.op = operator
  problem.secondarg = num2
  problem.calculate
  puts "Answer: #{problem.formatme}"

  #Prompt for another
  puts "Calculate another (y/n)? "
  stop = 1 if gets.chomp.to_s == "n"
end

puts "Hope your experience was numerical!"

