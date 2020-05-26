def caesar_cipher(string, shift)
  hash_lower = ("a".."z").each_with_index.to_h
  hash_upper = ("A".."Z").each_with_index.to_h
  string_arr = string.split("")
  new_string = ""
  string_arr.each do |letter|
    if ("a".."z").include?(letter)
      new_number = hash_lower[letter] + shift
        if new_number > 25
          new_number = new_number % 26
        end
      new_letter = hash_lower.key(new_number)
      new_string.concat(new_letter)
    elsif ("A".."Z").include?(letter)
      new_number = hash_upper[letter] + shift
        if new_number > 25
          new_number = new_number % 26
        end
      new_letter = hash_upper.key(new_number)
      new_string.concat(new_letter)
    else
      new_string.concat(letter)
    end
  end
  p new_string
end

puts "Please enter some text to encode: "
string_input = gets.chomp.to_s
puts "Please enter a shift factor for encoding (0-25): "
shift_input = Integer gets.chomp rescue nil

while shift_input == nil || shift_input < 0 || shift_input > 25
  puts "That's not an integer! Please enter a shift factor (0-25): "
  shift_input = Integer gets.chomp rescue nil
end
puts "Your encoded message is: "
caesar_cipher(string_input, shift_input)