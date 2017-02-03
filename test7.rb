def <=> (other)
  self_num, self_string = self.split(' ')
  other_num, other_string = other.split(' ')
  self_num > other_num ? 1 : other_num > self_num ? -1 :
    self_string > other_string ? -1 : 1
end
arr = ['2 xxx', '20 axxx', '2 m', '38 xxxx', '20 bx', '8540 xxxxxx', '2 z']
arr.sort! { |x, y| y <=> x }
puts arr

h = { "a" => 100, "b" => 200 }
h.each {|key| puts "key is #{key}" }

puts Time.new.year
