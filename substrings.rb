my_dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(string, dictionary)
  result = Hash.new(0)
  string.split(" ").each do |substring|
    dictionary.reduce(result) do |counts_hash, word|
      counts_hash[word] += 1 if substring.downcase.include?(word)
      counts_hash
    end
  end
  p result
end

print "Please enter some text to check how many times it appears in our dictionary: "
input = gets.chomp
puts '{"WORD"=>TIMES IT APPEARS}'
substrings(input, my_dictionary)