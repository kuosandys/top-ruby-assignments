def bubble_sort(array)
  sorted_array = []
  while array.length > 1
    array.each_with_index do |num, index|
      if index < (array.length-1)
        next_num = array[index+1]
        if num > next_num
          array[index+1] = num
          array[index] = next_num
        end
      end
    end
    last_num = array.pop
    sorted_array.unshift(last_num)
  end
  last_num = array.pop
  sorted_array.unshift(last_num)
  return sorted_array
end

puts "Enter a list of numbers and I will put them in order!"
puts "Please separate your numbers with commas: "
user_input = gets.chomp.split(",")
active = true

while active
  if user_input.kind_of?(Array) && user_input.length > 0 && (user_input.all? {|x| x == x.to_i.to_s})
    sorted_array = bubble_sort(user_input.map(&:to_i))
    puts "Your numbers are sorted: #{sorted_array}"
    active = false
  else
    puts "Please enter a valid list of numbers! Type 'q' to quit"
    user_input = gets.chomp.split(",")
      if user_input == ['q']
        active = false
      end
  end
end