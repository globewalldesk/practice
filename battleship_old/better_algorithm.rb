module BetterAlgorithm

# Uses recursion; ends if hits x or y is out of range (a wall),
# or if it hits 'x' or a sunken ship.
def calculate_score(board, x, y, v, h, pm, recursion_level, score)
  if pm == "plus"
    # puts "[y+v][x+h] = [#{y}+#{v}][#{x}+#{h}]" # FOR TESTING

    if (y+v > 9) && (v > 0) # first check if you've hit a wall
      score += 0.5 * recursion_level # COMMENTING OUT WALL BONUS
      return score
    end
    if (x+h > 9) && (h > 0) # first check if you've hit a wall
      score += 0.5 * recursion_level # COMMENTING OUT WALL BONUS
      return score
    end

    case board[y+v][x+h]
    when "." then
      # note the score declines with recursion level
      score += 4 - (recursion_level * 1.25)
      # puts "#{x}, #{y}: #{x+h}, #{y+v}; v: #{v}; rl: #{recursion_level}; score: #{score}: #{board[y+v][x+h]} " # FOR TESTING
      # print "#{4 - recursion_level} " # FOR TESTING
      return score if recursion_level == 3 # exits after four recurses
      recursion_level += 1
      v += 1 if v > 0 # step away from index, if recursing
      h += 1 if h > 0 # ditto
      score = calculate_score(board, x, y, v, h, pm, recursion_level, score) # recurse when a dot!
    when "x" then
      return score # if you hit a "missed" spot, that's worse than a wall...
    when "#" then
      score += 80 - (recursion_level * 20)
      return score if recursion_level == 3 # exits after four recurses
      recursion_level += 1
      v += 1 if v > 0 # step away from index, if recursing
      h += 1 if h > 0 # ditto
      score = calculate_score(board, x, y, v, h, pm, recursion_level, score) # recurse when a dot!
      return score
    end
  end

  if pm == "minus"
    if (y-v < 0) && (v > 0) # first check if you've hit a wall
      score += 0.5 * recursion_level # COMMENTING OUT WALL BONUS
      return score
    end
    if (x-h < 0) && (h > 0) # first check if you've hit a wall
      score += 0.5 * recursion_level # COMMENTING OUT WALL BONUS
      return score
    end
    case board[y-v][x-h]
    when "." then
      score += 4 - (recursion_level * 1.25)
      # puts "#{x}, #{y}: #{x-h}, #{y-v}; v: #{v}; rl: #{recursion_level}; score: #{score}: #{board[y-v][x-h]} " if x == 0 || y == 0 # FOR TESTING
      # print " y-v: #{y}-#{v} " if x == 1 && y == 1 # FOR TESTING
      # print "#{4 - recursion_level} " # FOR TESTING
      return score if recursion_level == 3 # exits after four recurses
      recursion_level += 1
      v += 1 if v > 0 # step away from index, if recursing
      h += 1 if h > 0 # ditto
      score = calculate_score(board, x, y, v, h, pm, recursion_level, score) # recurse when a dot!
    when "#" then
      score += 80 - (recursion_level * 20)
      return score if recursion_level == 3 # exits after four recurses
      recursion_level += 1
      v += 1 if v > 0 # step away from index, if recursing
      h += 1 if h > 0 # ditto
      score = calculate_score(board, x, y, v, h, pm, recursion_level, score) # recurse when a dot!
    when "x" then
      return score # if you hit a "missed" spot, that's worse than a wall...
    end
  end

  board[y-v][x-h] if pm == "minus"

  return score
end

def spot_scores(board, x, y)
  # print "\n#{x}, #{y}:  " # FOR TESTING

  # Single method inputs v, h, plus_or_minus; outputs score for a direction.
  # Note, arguments are: # board, x, y, vertical search, horizontal search,
  # plus-or-minus, recursion level (initialized at 0), score (initialized at 0)
  # Calculate right
  # print " > " # FOR TESTING
  right = calculate_score(board, x, y, 0, 1, "plus", 0, 0)
  # Calculate down
  # print " _ " # FOR TESTING
  down = calculate_score(board, x, y, 1, 0, "plus", 0, 0)
  # Calculate left
  # print " < " # FOR TESTING
  left = calculate_score(board, x, y, 0, 1, "minus", 0, 0)
  # Calculate up
  # print " ^ " # FOR TESTING
  up = calculate_score(board, x, y, 1, 0, "minus", 0, 0)

  # Add 'em up and return
  return right + down + left + up
end

def better_algorithm(board, points)
  points_hash = {} # keys = coords, values = points
  x = 0 # to count x indexes
  y = 0 # to count y indexes

  # Go through each spot on the board; another method assigns it a score.
  board.each do |row| # row indexes = y values
    row.each do |spot| # spot indexes = x values
      if board[y][x] == "."
        points_hash[[y,x]] = spot_scores(board, x, y)
      else # spot is already uncovered
        points_hash[[y,x]] = 0
      end
      # print "#{x}, #{y} " # FOR TESTING
      x += 1
    end
    x = 0 # start over at 0 at the beginning of each row, of course
    y += 1
  end

  # Return top-scoring coords!
  coords = points_hash.key(points_hash.values.max)
  # puts "points_hash.values.max = #{points_hash.values.max}; coords = #{coords}" # FOR TESTING
  return points_hash, coords[1], coords[0]
end # of better_algorithm

end # of BetterAlgorithm entire module
