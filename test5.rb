arr = ['2 xxx', '20 axxx', '2 m', '38 xxxx', '20 bx', '8540 xxxxxx', '2 z']
hash = {}
arr.each do |str|
  k, v = str.split(' ')
  hash[k.to_i] ||= []
  hash[k.to_i] << v
end
hash = hash.sort.reverse.to_h
newarr = []
hash.each do |k, v|
  inner_arr = hash[k].sort_by { |k, v| v }
  inner_arr.each { |item| newarr << [k, item].join(" ") }
end
puts newarr
