#!/usr/bin/env ruby -w
game_on = true
wins = 0
losses = 0

def get_choice
  choice_ok = false
  until choice_ok
    print "Choose a door! Must be A, B, or C: "
    choice = gets.chomp
    choice = "x" if choice == ""
    return choice.upcase if "AaBbCcx".include? (choice)
    puts "Invalid choice."
  end
end

# Loop for multiple rounds.
while (game_on == true)
  # Randomly assign car door and goats
  car = "ABC"[rand(3)]

  # User chooses a door. Must be A, B, or C.
  choice = get_choice
  choice = "A" if choice == "X"
  puts "You chose #{choice}!"

  # Monty randomly opens a door that has a goat behind it (but not the one you picked).
  other_doors = ["A", "B", "C"].reject { |letter| letter == choice || letter == car }
  # Tricky! It's random only if both other doors are goats!
  if other_doors.length == 2
    opened = other_doors[rand(2)]
  else
    opened = other_doors[0]
  end
  puts "OK! Monty reveals what's behind door #{opened}! A goat!"

  # Monty gives you the option to switch to the other door.
  last_door = ["A", "B", "C"].reject { |letter| letter == choice || letter == opened }
  other_door = last_door[0]
  print "Do you wish to switch to door #{other_door} (y/n)? "
  switch = gets.chomp

  # If user opts to switch, the choice is switched.
  if ["Yes", "yes", "Y", "y", ""].any? {|x| x == switch}
    choice = other_door
    puts "Switching to #{choice}!"
  else
    puts "OK, not switching!"
  end

  # Win/loss is announced and updated.
  if choice == car
    puts "You won the car! Woo hoo!"
    wins += 1
  else
    puts "Oh, a goat. You lose this time."
    losses += 1
  end

  # Tallies reported.
  puts "You have won #{wins} cars and #{losses} goats."
  ratio = 0
  if losses > 0 && wins > 0
    ratio = format("%1.2f", wins.to_f/losses.to_f)
  end
  puts "Your current win/loss ratio is #{wins}:#{losses}."
  puts "That's a ratio of #{ratio} to 1." if ratio != 0

  # Prompt to continue; end if not.
  print "Go again or perform 1,000,000 trials? (y/n/t) "
  again = gets.chomp
  unless ["Yes", "yes", "Y", "y", ""].any? {|x| x == again}
    game_on = false
  end
end
