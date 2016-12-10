# create array of sample data, with some hard-to-sort items
words_to_sort = %w(Mariah Carly Aaron Zachariah Albert Ed !`~$ Charles Alvin Hen
  Sarah Doug Iris Henry Eddie &$%* Rita Margarita Larry Edward Ed Lawrence Edwin
  H&K@#fjk378 ks9f23f 8925723595 34 327 \)*^$)

# create a method that compares two letters and determines which is first
def sort_letters(x, y)
  alphabet = 255.times.map { |char| char.chr }
  alphabet.find_index(x) <=> alphabet.find_index(y)
end

# use letter-comparison method to create a method to compare whole word arrays
# x and y are both word *arrays*
def sort_words(x, y)
  index = 0
  while index >= 0
    case sort_letters(x[index], y[index])
    when 1
      then return 1
    when -1
      then return -1
    end
    index += 1
    return 0 if x[index] == nil && y[index] == nil
    if x[index] == nil
      return -1
    else
      return 1 if y[index] == nil
    end
  end
end

# use word-comparison array to perform linear/insertion sort of sample data
def linear_sort_words(words)
  words.map! { |word| word.split(//) }
  1.upto(words.length - 1) do |index|
    index.downto(0) do |comp_index|
      next if index == comp_index
      if sort_words(words[comp_index + 1], words[comp_index]) == -1
        words.insert(comp_index, words.delete_at(comp_index + 1))
      else
        break
      end
    end
  end
  return words.map { |word| word.join }
end

puts "Words to sort: #{words_to_sort}"
puts "Sorted: #{linear_sort_words(words_to_sort)}"
