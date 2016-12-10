print rand(4)
my_hash = Hash.new
my_hash = my_hash.merge({"C" => 0, "Uh" => 4})
my_hash = my_hash.merge("D" => 2, "E" => 3)
p my_hash
if 0
  puts "0 is truthy!"
end
cool = "yo".to_sym
p cool
puts my_hash.keys

p my_hash
array = my_hash.find_all {|key, value| key > "D"}
my_hash.select! {|key, value| key > "D"}
p my_hash
p array
my_arr = [1, 2, 3, 4, 5, 6]
p my_arr.select {|x| x > 3}
p my_arr.find_all {|x| x > 3}
p my_arr.collect {|x| x > 3}
puts "YAAAARRGHH!!".downcase

mystring = "ixnay on the etchupkay."
puts mystring
mystring.gsub!("ay", "ee")
puts mystring
mystring.gsub!(/ee/, "oy")
puts mystring
