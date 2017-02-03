toFahrenheit = ->(degCent) do
  degFahren = format("%.2f",((9.0 / 5.0 * degCent) + 32.0))
  puts "#{degCent} Celsius is #{degFahren} Fahrenheit."
end

puts 9.0 / 5.0
puts 24 + 32.0

toCentigrade = ->(degFahren) do
  degCent = (5 / 9.0 * (degFahren - 32)).round(2)
  puts "#{degFahren} Fahrenheit is #{degCent} Celsius."
end

def convert(converter, temp)
  converter.call(temp)
end

convert(toFahrenheit, 24);
convert(toCentigrade, 75);

puts format("%.2f",123.45678)
puts (123.45678).round(2)

puts "Random number for you: #{rand(5..10)}"
#new Random().nextInt(max) + min;

=begin
function toCentigrade(degFahren) {
  var degCent = 5/9 * (degFahren - 32);

  document.write(degFahren + " Fahrenheit is " +
                 degCent + " Celsius.<br />");
}

function toFahrenheit(degCent) {
  var degFahren = 9/5 * degCent + 32;

  document.write(degCent + " Celsius is " +
                 degFahren + " Fahrenheit.<br />");
}

function convert(converter, temperature) {
  converter(temperature);
}

convert(toFahrenheit, 24);
convert(toCentigrade, 75);
=end
