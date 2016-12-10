class Person
  attr_accessor :name, :age, :occupation
  def initialize (name, age:, occupation: "Programmer")
    @name = name
    self.age = age
    self.occupation = occupation
  end
  def my_info
    puts "Name: #{name}"
    puts "Age: #{age}"
    puts "Occupation: #{occupation}"
  end
end


joebob = Person.new("Joe Bob", age: 34)
joebob.my_info
