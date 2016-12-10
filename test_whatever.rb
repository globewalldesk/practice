class Dog

  # Reads the dog name and age
  attr_reader :name, :age

  def name= (value)
    if value == ""
      raise "Name can't be blank!"
    end
    @name = value
  end

  def age= (value)
    # First checks that value is either a Fixnum or a Float
    if (! value.is_a? Fixnum) && (! value.is_a? Float)
      raise "A number is required!"
    elsif value < 0
      raise "An age of #{value} isn't valid!"
    end
    @age = value
  end

  # Has the dog bark, using name
  def talk
    puts "#{@name} says Bark!"
  end

  # Has the dog move to a destination, using name
  def move(destination)
    puts "#{@name} runs to the #{destination}."
  end

  # Reports the dog's age (long form)
  def report_age
    puts "#{@name} is #{@age} years old."
  end

end

dog = Dog.new
dog.name = "Daisy"
dog.age = 3
dog.report_age
dog.talk
dog.move("bed")