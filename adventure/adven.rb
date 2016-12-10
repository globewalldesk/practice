# each player action = one turn
$turn = 0

class Player
  attr_accessor :name, :xpos, :ypos, :inven, :clothes

  def initialize (name:)
    self.name = name
    # player starts at position 1, 1 on 0-2 x 0-2 grid
    self.xpos = 1;
    self.ypos = 1;
    self.clothes = "starter clothes"
    self.inven = ["matches", "house key", "umbrella"]
  end
end

class World

  # an algorithm generates a section of the world approximately 100 miles square
  # this assigns to each square such things as paths, towns, forests, deserts,
  # swamps, mountains, caves, castles, and lairs.
  def generate_world
  end

end

class Place
#  self.description = "a richly-furnished room"
end

def setup_player
  p "What's your adventurer's name? "
  name = gets.chomp
  Player.new(name:name)
end

# The command line, which prints output and accepts commands
def command
  puts "Let's set up your character."
  player = setup_player
  p player
end

$game_on = true
# continue game until game is off!
while $game_on
  command
  $game_on = false
end
