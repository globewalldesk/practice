class SpecialStr
  include Comparable
  attr_accessor :str
  def initialize (str)
    @str = str
  end

  def <=> (other)
    self_num, self_string = @str.split(' ')
    other_num, other_string = other.str.split(' ')
    self_num > other_num ? 1 : other_num > self_num ? -1 :
      self_string > other_string ? -1 : 1
  end
end

arr = ['2 xxx', '20 axxx', '2 m', '38 xxxx', '20 bx', '8540 xxxxxx', '2 z']
arr_object = []
arr.each { |str| arr_object << SpecialStr.new(str) }
arr_object.sort! { |x, y| y <=> x }
output_arr = []
arr_object.each { |obj| output_arr << obj.str}
puts output_arr
