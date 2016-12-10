#!/usr/bin/env ruby -w
# MAIN CLASS
# Car, goats, and first player choice are all to be in the initialization method.
# The other two methods generate/calculate the rest of the trial.
# Loosely based on the design from
# http://programmingzen.com/monte-carlo-simulation-of-the-monty-hall-problem-in-ruby-and-python/
class Trial
  attr_accessor :doors, :player_first_pick, :opened_door
  def initialize
    self.doors = ['goat', 'goat', 'car'].shuffle
    self.player_first_pick = rand(3)
  end

  def door_to_open
    door_possibilities = [0, 1, 2]
    # Reject the index of the player pick and of the car
    door_possibilities.reject! { |num| num == player_first_pick || num == doors.index('car') }
    self.opened_door = door_possibilities[rand(door_possibilities.length)]
  end

  def switch_and_stay
    # Armed with the car index, player_first_pick, and opened_door,
    # it is straightforward to calculate whether staying or switching wins.
    if doors.index('car') == player_first_pick
      $stay_wins += 1
    else
      $switch_wins += 1
    end
  end
end

# These global variables hold the ratio
$switch_wins = 0
$stay_wins = 0

# Input valid number of user trials
trials = 0
until trials.class == Fixnum && trials > 0
  print "Monty Hall! How many trials do you want? "
  trials = gets.chomp.to_i
end

# MAIN Loop
# Execute a trial as many times as the user specified
trials.times do
  # Initialize trial
  trial = Trial.new
  # Determine door to open
  trial.door_to_open
  # Make switch and stay calculations and increment variables
  trial.switch_and_stay
end
puts "There were #{trials} trials."
puts "Switching won #{$switch_wins} times (#{(($switch_wins/trials.to_f)*100)}%)."
puts "Staying won #{$stay_wins} times (#{(($stay_wins/trials.to_f)*100)}%)."
