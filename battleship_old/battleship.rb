require "./test_index.rb" # to include AITestSuite module, for AI functions
require "./better_algorithm.rb" # a better way to choose what to attack next
$winner = nil # tells parser who the winner is; nil = game not over
$testing = true # not used at present
$message = '' # stuff that is saved to be displayed to the user after the board
$random = true # half the time, the computer guesses randomly

############
## CLASSES #
############
class Board
  # my first mixin!
  include AITestSuite # separating complicated AI for clarity
  include BetterAlgorithm # a better way to choose what to attack next; may replace AITestSuite
  attr_accessor :pc, :board, :carrier, :battleship, :warship, :submarine, :destroyer, :player_view, :points_hash

  # generates blank board and populates it with five pieces
  def initialize (pc)
    @pc = pc
    @board = generate_blank_board
    self.points_hash = {[] => 0}
  end

  def generate_blank_board
    blank_board = []
    10.times do |y|
      blank_board[y] = []
      10.times { |x| blank_board[y][x] = "." }
    end
    # Note, x is horizontal, y is vertical, counting from upper left
    # Also, x are the nested array indices, y is outer indices: [y][x]
    blank_board
  end

  def write_ship_to_board(options)
    char = options[:type][0].upcase
    length = options[:length]
    x = options[:x]
    y = options[:y]
    orientation = options[:orientation]
    if orientation == 1 # horizontal
      # iterate "length" times, placing char as you go
      length.times do |n|
        self.board[y][x+n] = char
      end
    else # vertical
      # iterate "length" times, placing char as you go
      length.times do |n|
        self.board[y+n][x] = char
      end
    end
  end

  def display_board (*board)
    if board[0] == "player"
      puts "=========="
      puts "ENEMY ZONE"
    else
      puts "========="
      puts "YOUR ZONE"
    end
    puts "      a   b   c   d   e   f   g   h   i   j", "\n"
    n = 0
    if board[0] == "player" # use player view of computer board
      self.player_view.each do |row|
        printable = "#{n+1} " if n < 9
        printable = "#{n+1}" if n == 9
        row.each {|item| printable << ("   " + item) }
        print " #{printable}\n\n" if n < 9
        print " #{printable}\n" if n == 9
        n += 1
      end
    else # use player view of player board if no arguments
      self.board.each do |row|
        printable = "#{n+1} " if n < 9
        printable = "#{n+1}" if n == 9
        row.each {|item| printable << ("   " + item) }
        print " #{printable}\n\n" if n < 9
        print " #{printable}\n" if n == 9
        n += 1
      end
    end
    print "\n"
  end

  def get_valid_coords(*type)
    x = 0
    y = 0
    valid_start = false
    $message << "You attack! "
    until valid_start
      if type[0]
        puts "Where do you want the top/left edge of your #{type[0]}? "
      else
        print "Missile ready to launch. Coordinate? "
      end
      print "E.g., a1: "
      coords = gets.chomp
      begin
        x = coords[0]
        coords[0] = ''
        y = coords.to_i
        valid_start = true if "abcdefghij".include?(x) && x.length == 1 && y.between?(1,10)
      rescue ArgumentError, TypeError
        puts "Format example: a1 "
        next
      end
    end
    # convert human coords into array indices
    return "abcdefghij".index(x), y-1
  end

  def show_player_view
    self.player_view ||= generate_blank_board
    display_board("player")
    message
  end

  def show_player_view_of_player
    self.player_view ||= generate_blank_board
    display_board
    message
  end

  # help! what do I do to avoid this repetition?
  def record_damage (x, y, ship_type) # Type = C, B, W, S, or D
    case ship_type
    when 'C'
      then self.carrier.points[[x,y]] = '#'
    when 'B'
      then self.battleship.points[[x,y]] = '#'
    when 'W'
      then self.warship.points[[x,y]] = '#'
    when 'S'
      then self.submarine.points[[x,y]] = '#'
    when 'D'
      then self.destroyer.points[[x,y]] = '#'
    end
  end

  # help! what do I do to avoid this repetition?
  def report_if_sunk(ship_type)
    case ship_type
    when 'C'
      then $message << "Carrier sunk! " if self.carrier.points.values.all? {|x| x == '#'}
      return true if self.carrier.points.values.all? {|x| x == '#'}
    when 'B'
      then $message << "Battleship sunk! " if self.battleship.points.values.all? {|x| x == '#'}
      return true if self.battleship.points.values.all? {|x| x == '#'}
    when 'W'
      then $message << "Warship sunk! " if self.warship.points.values.all? {|x| x == '#'}
      return true if self.warship.points.values.all? {|x| x == '#'}
    when 'S'
      then $message << "Submarine sunk! " if self.submarine.points.values.all? {|x| x == '#'}
      return true if self.submarine.points.values.all? {|x| x == '#'}
    when 'D'
      then $message << "Destroyer sunk! " if self.destroyer.points.values.all? {|x| x == '#'}
      return true if self.destroyer.points.values.all? {|x| x == '#'}
    end
    $message << "Not sunk yet. "
    return false
  end

  def change_to_letters(ship_type)
    case ship_type
    when 'C'
      then self.carrier.points.keys.each do |key|
        x, y = key[0], key[1]
        player_view[y][x] = 'C'
      end
    when 'B'
      then self.battleship.points.keys.each do |key|
        x, y = key[0], key[1]
        player_view[y][x] = 'B'
      end
    when 'W'
      then self.warship.points.keys.each do |key|
        x, y = key[0], key[1]
        player_view[y][x] = 'W'
      end
    when 'S'
      then self.submarine.points.keys.each do |key|
        x, y = key[0], key[1]
        player_view[y][x] = 'S'
      end
    when 'D'
      then self.destroyer.points.keys.each do |key|
        x, y = key[0], key[1]
        player_view[y][x] = 'D'
      end
    end
  end

  def determine_if_game_over
    if self.carrier.points.values.all? {|x| x == '#'} &&
      self.battleship.points.values.all? {|x| x == '#'} &&
      self.warship.points.values.all? {|x| x == '#'} &&
      self.submarine.points.values.all? {|x| x == '#'} &&
      self.destroyer.points.values.all? {|x| x == '#'}
      # then
      $winner = self.pc
      # winner is the opposite of the one whose board is being changed
      case $winner
      when "player"
        then $winner = "computer"
      when "computer"
        then $winner = "player"
      end
      $message << "We have a winner! "
    else
      $message << "No winner yet. "
    end
  end

  def compu_coords_to_human_coords (x,y)
    # puts "x = #{x}, y = #{y}" # FOR TESTING
    x = "abcdefghij"[x]
    y += 1
    return x, y
  end

  def determine_damage (x, y)
    ship_type = board[y][x]
    hit = false
    x_human, y_human = compu_coords_to_human_coords(x,y)
    $message << "Trying #{x_human}#{y_human}. "
    # edit player_view based on hit/miss
    case board[y][x]
      when '.'
        then $message << "\nMISS! "
        player_view[y][x] = 'x'
        board[y][x] = 'x'
      when 'C', 'B', 'W', 'S', 'D'
        then $message << "\nHIT! "
        hit = true
        player_view[y][x] = '#'
        # This overwrites the board but ship coords are in ship object
        if pc == "computer"
          board[y][x] = "#"
        elsif pc == "player"
          board[y][x] = board[y][x].downcase
        end
        record_damage(x, y, ship_type)
        sunk = report_if_sunk(ship_type)
        change_to_letters(ship_type) if sunk == true
        determine_if_game_over if sunk == true
      else
        $message << "Invalid coordinates: #{x_human}#{y_human}. "
        show_player_view
        return hit, false # ship not sunk, and coordinates were bad
    end

    return hit, true # i.e., whether ship was sunk, and if coordinates were OK
  end

end

class Ship
  attr_accessor :type, :char, :length, :x, :y, :orientation, :points

  def initialize (options)
    self.type = options[:type]
    self.char = options[:type][0].upcase
    self.length = options[:length]
    self.x = options[:x]
    self.y = options[:y]
    self.orientation = options[:orientation]
    initialize_ship_points
  end

  def initialize_ship_points
    # a hash of ship points, with keys = an array of coordinates
    # and values = state of that point ('.' or '#')
    self.points = {}
    if orientation == 0 # vertical
      length.times do |n|
        points[[x, y+n]] = "."
      end
    else # horizontal
      length.times do |n|
        points[[x+n, y]] = "."
      end
    end
  end
end

class ComputerBoard < Board

  def initialize (pc)
    puts "Generating computer's board."
    super
    self.pc = "computer" # is there a way to avoid this??
    place_object(5, "carrier")
    place_object(4, "battleship")
    place_object(3, "warship")
    place_object(3, "submarine")
    place_object(2, "destroyer")
  end

  def place_object(length, type)
    position_found = false
    orientation = nil
    x = nil
    y = nil
    # generate new positions until a valid one is found
    until position_found
      # choose horizontal or vertical
      orientation = rand(2)
      # randomly choose starting point
      x = rand(10)
      y = rand(10)
      # test legality of proposed placement points within board array
      if orientation == 1 # horizontal
        pass = true
        # iterate "length" times, checking each position as you go
        length.times do |n|
          begin # wrap to catch off-board exceptions
            # check if position already occupied
            pass = false unless self.board[y][x+n] == "."
          rescue NoMethodError
            pass = false
            break
          end
          break unless pass
        end
        if pass == true
          puts "  #{type.capitalize} placed."
          position_found = true
        end
      else # vertical
        pass = true
        # iterate "length" times, checking each position as you go
        length.times do |n|
          begin # wrap to catch off-board exceptions
            # check if position already occupied
            pass = false unless self.board[y+n][x] == "."
          rescue NoMethodError
            pass = false
            break
          end
          break unless pass
        end
        if pass == true
          position_found = true
          puts "  #{type.capitalize} placed."
        end
      end
    end
    # save ship
    case type
    when "carrier"
      then @carrier = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    when "battleship"
      then @battleship = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    when "warship"
      then @warship = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    when "submarine"
      then @submarine = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    when "destroyer"
      then @destroyer = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    end
    # write to board
    write_ship_to_board(type: type, length: length, x: x, y: y, orientation: orientation)
  end

end

class PlayerBoard < Board
  def initialize (pc)
    super
    self.pc = "player" # is there a way to avoid this??
    puts "Let's set up your board!"
    place(5, "carrier")
    place(4, "battleship")
    place(3, "warship")
    place(3, "submarine")
    place(2, "destroyer")
  end

  def test_legality_of_x_and_y(x, y, length, type, orientation, position_found)
    if orientation == 0 # horizontal
      pass = true
      # iterate "length" times, checking each position as you go
      length.times do |n|
        begin # wrap to catch off-board exceptions
          # check if position already occupied
          unless self.board[y+n][x] == "."
            pass = false
            puts "That position is invalid."
          end
        rescue NoMethodError
          pass = false
          puts "Error. That position is invalid."
          break
        end
        break unless pass
      end
      if pass == true
        position_found = true
      end
    else # vertical
      pass = true
      # iterate "length" times, checking each position as you go
      length.times do |n|
        begin # wrap to catch off-board exceptions
          # check if position already occupied
          unless self.board[y][x+n] == "."
            pass = false
            puts "That position is invalid."
          end
        rescue NoMethodError
          pass = false
          puts "That position is invalid."
          break
        end
        break unless pass
      end
      if pass == true
        position_found = true
      end
    end
    return x, y, position_found
  end

  def place(length, type)
    self.display_board unless $testing
    message unless $testing
    position_found = false
    orientation = nil
    valid_orientation = false

#=begin UN-COMMENT OUT AFTER TESTING
    # ask for a position until a valid one is chosen
    until position_found
      # choose horizontal or vertical
      orient = ""
      until valid_orientation
        print "Do you want your #{type} [h]orizontal or [v]ertical? "
        orient = gets.chomp
        if (orient == "h")
          orientation = 1
          valid_orientation = true
        elsif (orient == "v")
          orientation = 0
          valid_orientation = true
        else
          puts "Please, either 'h' or 'v'."
        end
      end
      # solicit valid x and y from player
      x, y = get_valid_coords(type)
      # test legality of proposed placement points within board array
      x, y, position_found = test_legality_of_x_and_y(x,y,length,type,orientation,position_found)
    end
#=end

=begin
    # TESTING CODE, REMOVE AFTER TESTING IS FINISHED
    case type
      when "carrier"
        then x, y, position_found, orientation = 0, 0, true, 1
      when "battleship"
        then x, y, position_found, orientation = 0, 1, true, 1
      when "warship"
        then x, y, position_found, orientation = 0, 2, true, 1
      when "submarine"
        then x, y, position_found, orientation = 0, 3, true, 1
      when "destroyer"
        then x, y, position_found, orientation = 0, 4, true, 1
    end
    # END TESTING CODE
=end

    # save ship
    case type
      when "carrier"
        then @carrier = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
      when "battleship"
        then @battleship = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
      when "warship"
        then @warship = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
      when "submarine"
        then @submarine = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
      when "destroyer"
        then @destroyer = Ship.new(type: type, length: length, x: x, y: y, orientation: orientation)
    end

    # write to board
    write_ship_to_board(type: type, length: length, x: x, y: y, orientation: orientation)
    show_player_view_of_player
  end

  def generate_random_coords
    random_coords_found = false
      x = 0
      y = 0
    until random_coords_found == true
      x = rand(10)
      y = rand(10)
      random_coords_found = true if player_view[y][x] == "."
    end
    return x, y
  end

  # pretty-prints a table of the point values
  def print_value_table(points_hash)
    10.times do |y|
      10.times do |x|
        print format("%3i ",points_hash[[y,x]])
      end
      print "\n"
    end
  end

  def pick_random_from_top_half_of_points_hash(points_hash)
    over_zero = points_hash.values.partition {|n| n > 0}
    top_half = over_zero[0].sort.each_slice(over_zero.length/2).to_a
    lucky_winner = top_half.sample(1) #randomly chooses from top half!
    return points_hash.key(lucky_winner[0][0])
  end

  def determine_computer_coords
    # 50% of the time, the computer guesses randomly.
    # 50% of the time, it uses a clever algorithm.
    # Except when any space is scored > 40.
    # toggle random guessing...
    $random == false ? $random = true : $random = false
    # ...except when sinking a ship
    $random = false if points_hash.values.max > 40

    # Guess randomly, among the top half of the points_hash
    if $random == true
      x, y = pick_random_from_top_half_of_points_hash(points_hash)
      return x, y
    else # Use clever algorithm
      self.points_hash, x, y = better_algorithm(player_view, points_hash)
      print_value_table(points_hash)
      # puts "x, y = #{x}, #{y}, value = #{points_hash[[y,x]]}" # FOR TESTING
      return x, y
    end

=begin COMMENTING OUT BAD OLD ALGORITHM
    index = [] # Will be coords of '#'
    # looks systematically through each spot for '#'
    coords_found = false
    x, y = 0, 0
    player_view.each do |row|
      row.each do |item|
        # IMPORTANT: uses AITestSuite!
        # note, continues testing new indexes unless coords_found == true
        x, y, coords_found = test_index(x,y)
        break if coords_found == true
        x += 1
      end
      break if coords_found == true
      x = 0
      y += 1
=end
    end # of determine_computer_coords

end

############
## METHODS #
############
# This is called just after displaying a board, so that messages appear
# below the board instead of above them.
def message
  puts $message
  $message = ''
end

def setup_game
  computer_board = ComputerBoard.new("computer")
  computer_board.display_board # for testing
  player_board = PlayerBoard.new("player")
  player_board.display_board unless $testing
  player_board.player_view = player_board.generate_blank_board
  $message << "Setup complete! Let's play! "
  message
  return computer_board, player_board
end

def flip_to_see_who_goes_first
  result = rand(2)
  return nil if result == 0
  "player"
end

def player_turn (computer_board, player_board)
  $message << "Your turn! "
  hit = true # to get into the while loop
  # continue as long as player is hitting
  while hit == true
    hit = false # hasn't hit yet
    # show player what he knows of enemy board
    computer_board.show_player_view
    valid_coords = false
    until valid_coords
      x, y = computer_board.get_valid_coords
      # determine_damage returns 'false' if already attacked coords
      hit, valid_coords = computer_board.determine_damage(x, y)
      return if $winner
    end
  end
  # show player view of computer board at end of player turn
  computer_board.show_player_view
  print "Enter to continue..."
  gets
end

def computer_turn (computer_board, player_board)
  $message << "The enemy attacks! "
  hit = true # to get into the while loop
  # continue as long as player is hitting
  while hit == true
    hit = false # hasn't hit yet
    valid_coords = false
    until valid_coords
      x, y = player_board.determine_computer_coords
      # determine_damage returns 'false' if already attacked coords
      hit, valid_coords = player_board.determine_damage(x, y)
      # show player his own board, with new damage done
      player_board.show_player_view_of_player
      return if $winner
      print "Enter to continue..."
      gets
    end
  end
end

def play_game
  computer_board, player_board = setup_game
  player_move = flip_to_see_who_goes_first
  puts "The #{player_move ? "player" : "computer"} won the toss."
  # code to play game goes here
  until $winner # i.e., until a winner is determined
    player_move ? player_turn(computer_board, player_board) :
      computer_turn(computer_board, player_board)
    # toggle until game ends
    player_move ? player_move = false : player_move = true
  end
  return computer_board, player_board
end

def report_and_prompt(computer_board, player_board)
  $winner == "computer" ? player_board.show_player_view_of_player :
    computer_board.show_player_view
  puts "The winner of this round is the #{$winner}!"
end

# enclosing loop
game_on = true
while game_on == true
  computer_board, player_board = play_game
  # reports results and prompts for another game
  report_and_prompt(computer_board, player_board)
  game_on = false
end
