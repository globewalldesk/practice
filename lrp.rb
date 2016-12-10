$all_widgets = {}

# Begin by defining the widget class
class Widget
  def initialize (name = "Unspecified", price = 0.0, size = "n/a")
    self.name = name
    self.price = price
    self.size = size
  end

  attr_reader :name
  attr_reader :price
  attr_reader :size

  def name= (name)
    if name == ""
      raise "Name cannot be blank!"
    end
    @name = name
  end

  def price= (price)
    if price < 0.00
      raise "Price cannot be negative!"
    end
    @price = price.to_f
  end

  def size= (size)
    unless size == "" || size == "sm" || size == "med" || size == "lg"
      raise "Invalid size!"
    end
    @size = size
  end
  
  def change_attribute_values
	puts "Changing the widget. Current values:"
	# Display current attributes and values
	display_object
	# Find out which attribute the user wants to change
	# Exit method with appropriate message if no change is made
	change = solicit_change
	puts "No change made." and return if change == "no choice"
	# Change the value
	change_value(change)
  end

  # Given an object as parameter, display its contents
  def display_object
	puts "Name: #{name}"
	pretty_price = format("%0.2f", price)
	puts "Price: $#{pretty_price}"
	puts "Size: #{size}"
  end
  
  def solicit_change
    puts "Type the attribute you want to change."
	choice = gets.chomp
	case choice
	  when "Name", "name" then choice = name
	  when "Price", "price" then choice = price
	  when "Size", "size" then choice = size
	  else choice = "no choice"
	end
	return choice
  end
  
  def change_value (change)
    case change
	  when name then 
	    puts "Enter widget name:"
		self.name = gets.chomp
	  when price then
	    puts "Enter widget price:"
		self.price = gets.to_f
	  when size then
	    puts "Enter widget size (sm, med, lg only):"
		self.size = gets.chomp
	  end
	puts "Value updated."
  end
  
end

def create_new_widget
  puts "Creating new widget."
  puts "Enter widget name:"
  name = gets.chomp
  puts "Enter widget price:"
  price = gets.to_f
  puts "Enter widget size (sm, med, lg only):"
  size = gets.chomp
  my_widget = Widget.new(name, price, size)
  # Add to hash of all widgets
  $all_widgets[my_widget.name] = [my_widget.price, my_widget.size]
  puts "Here is your new widget:"
  my_widget.display_object
  return my_widget
end

widg = create_new_widget
widg.display_object
widg2 = create_new_widget
widg2.display_object
puts "$all_widgets =", $all_widgets
