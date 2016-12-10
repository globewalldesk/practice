module AITestSuite

class Index
  attr_accessor :x, :y, :dir, :horiz, :vert, :found

  def initialize (x, y)
    @x = x
    @y = y
    @horiz = nil # nil until horizontal search = 'done'
    @vert = nil # nil until vertical search = 'done'
    @found = nil # nil until a dot (attackable position) is found
    @dot_x = nil # nil until dot x coordinate found
    @dot_y = nil # nil until dot y coordinate found
    dispatch_horiz_or_vert # set initial direction
  end

  # pick random direction to search initially
  def dispatch_horiz_or_vert
    case rand(2)
      when 0 then self.dir = "horiz"
      when 1 then self.dir = "vert"
    end
  end # of dispatch_horiz_or_vert
end # of class Index

# Wraps around the rest of the module's logic
def test_index(x,y)
  index_found = false # This isn't a dot, it's just testing for a '#'
  if player_view[y][x] == "#"
    # puts "testing index at x:#{x}, y:#{y}" # FOR TESTING
    index_found = true
  end
  return x, y, false if index_found == false # exit immediately if not an index
  index = Index.new(x,y)
  # puts "before search_for_dot, index.found == #{index.found}" # FOR TESTING
  index = search_for_dot(index, x, y)
  # puts "after search_for_dot, index.found == #{index.found}" # FOR TESTING
  # if search was successful, return the "dot" coords + "true" (yep, found)
  return @dot_x, @dot_y, true if index.found
  return x, y, false # PLACEHOLDER
end

# increment either v or h depending on assignment in search_for_dot
# if dot found, magically return! Returns index, which contains all relevant info.
def interating_search_right_or_down(index, x, y, v, h)
  # can't consider case where the position doesn't exist
  return index if player_view[index.y + v][index.x + h] == nil
  # This logic requires that the position be = '.', '#', 'x'; else a sunken ship.
  case player_view[index.y + v][index.x + h]
    when "."
      then
      # puts "I think I found a dot." # FOR TESTING
      index.found = true
      @dot_x = index.x + h
      @dot_y = index.y + v
      return index
    when "#"
      then
      puts "I think I found '#'. Continuing..." # FOR TESTING
      # Increment vertical or horizontal incrementers and retry the
      # resulting index!
      if index.dir == "vert"
        v += 1
        return index if v > 9 # off the board
      elsif index.dir == "horiz"
        h += 1
        return index if h > 9 # off the board
      end
      # Ooh, recursion! After incrementing v or h, simply redo the method.
      index = interating_search_right_or_down(index, x, y, v, h)
    when "x"
      then puts "I think I found 'x'. Not found in that direction." # FOR TESTING
      # no changes made, so next will try changing index.dir; logic in search_for_dot
      return index
  end
  return index # in case it hits a sunken ship
end

# similar to the right_or_down method
def interating_search_left_or_up(index, x, y, v, h)
    # can't consider case where the position doesn't exist
    return index if player_view[index.y - v][index.x - h] == nil
    # This logic requires that the position be = '.', '#', 'x', and nothing else.
    # minus, not plus
    case player_view[index.y - v][index.x - h]
    when "."
      then
      # puts "I think I found a dot." # FOR TESTING
      index.found = true
      @dot_x = index.x - h
      @dot_y = index.y - v
      return index
    when "#"
      then
      puts "I think I found '#'. Continuing..." # FOR TESTING
      # Decrement vertical or horizontal decrementers and retry the
      # resulting index!
      if index.dir == "vert"
        v -= 1
        return index if v < 0 # off the board!
      elsif index.dir == "horiz"
        h -= 1
        return index if h < 0 # off the board!
      end
      # Ooh, recursion! After decrementing v or h, simply redo the method.
      index = interating_search_right_or_down(index, x, y, v, h)
    when "x"
      then puts "I think I found 'x'. Not found in that direction." # FOR TESTING
      # no changes made, so next will try changing index.dir; logic in search_for_dot
      return index
  end
end

# The purpose of this method is to locate a dot in a specific direction.
# This same method is used for both horizontal and vertical.
# The logic is outsourced to another method. Can change index.found, @dot_x, @dot_y.
# Intention is to do this twice if necessary. Returns index.
def search_for_dot(index, x, y)

  #### POSITIVE, USES right_or_down ###
  if index.dir == "vert"
    v = 1
    h = 0
  elsif index.dir == "horiz"
    v = 0
    h = 1
  end
  puts "searching #{index.dir}" # FOR TESTING
  # puts "I propose to search x:#{index.x + h}, y:#{index.y + v}. Cool?" # FOR TESTING

  # Now, search right or down, in a positive direction
  puts "searching right_or_down" # FOR TESTING
  index = interating_search_right_or_down(index, x, y, v, h)
  # If no index yet, then try same positive search after toggling right/down
  if index.found
    return index
  else # dot not found yet!
    # first, toggle index.dir
    index.dir == "vert" ? index.dir = "horiz" : index.dir = "vert"
    puts "searching #{index.dir}" # FOR TESTING
    # then, reset v & h
    if index.dir == "vert"
      v = 1
      h = 0
    elsif index.dir == "horiz"
      v = 0
      h = 1
    end
    # now redo positive search after toggling
    index = interating_search_right_or_down(index, x, y, v, h)
    return index if index.found # dot found after toggling?
  end # Done with searching right_or_down

  #### NEGATIVE, USES left_or_up ###
  # first, ready v and h values again
  if index.dir == "vert"
    v = 1
    h = 0
  elsif index.dir == "horiz"
    v = 0
    h = 1
  end
  puts "searching #{index.dir}" # FOR TESTING
  puts "I propose to search x:#{index.x - h}, y:#{index.y - v}. Cool?" # FOR TESTING

  # Now search left or up, in a negative direction
  puts "searching left_or_up" # FOR TESTING
  index = interating_search_left_or_up(index, x, y, v, h)
  # If no index yet, then try same positive search after toggling right/down
  if index.found
    return index
  else # dot not found yet!
    # first, toggle index.dir
    index.dir == "vert" ? index.dir = "horiz" : index.dir = "vert"
    puts "searching #{index.dir}" # FOR TESTING
    # then, reset v & h
    if index.dir == "vert"
      v = 1
      h = 0
    elsif index.dir == "horiz"
      v = 0
      h = 1
    end
    # now redo negative search after toggling
    index = interating_search_left_or_up(index, x, y, v, h)
    return index if index.found # dot found after toggling?
  end # Done with searching right_or_down

  # If no dot after all that, return index
  return index
end

end # of whole module
