puts "I am a tester!"
$testola = "testing testing"

def return_string_length(string_input)
  puts "Testola is '#{$testola}'."
  string_input.length
end

puts return_string_length($testola)

myVariable = "ABC"
mySecondVariable = myVariable;
myVariable = "DEF"
puts mySecondVariable;

fred = "hello".split("")
derf = ""
fred.length.times { derf << fred.pop }
puts derf
