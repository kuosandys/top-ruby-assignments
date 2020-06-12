class RandomSolution
  attr_reader :array

  def initialize(num, colours)
    @num = num
    @colours = colours
    @array = Array.new(@num) {@colours.sample}
  end
end

class ComputerPlayer
  attr_accessor :array

  def initialize(length, colours)
    @array = Array.new((length), "-")
    @colours = colours
    @good_guess_array = []
  end

  def create_guess
    guess_str = ""
    @array.each_with_index do |sln,idx|
      if (sln == "-" && @good_guess_array.empty?) || sln == "0"
        guess_str += @colours.sample
      elsif sln == "-"
        sample = @good_guess_array.sample
        guess_str += sample
        @good_guess_array -= [sample]
      else
        guess_str += @array[idx]
      end
    end
    return Guess.new(guess_str).array
  end

  def update_solution(feedback_arr, last_guess)
    feedback_arr.each_with_index do |f, idx|
      if f == "1"
        @array[idx] = last_guess[idx]
      elsif f =="0"
        @good_guess_array.push(last_guess[idx])
        @array[idx] = "-"
      else
        @array[idx] = "-"
      end
    end
    return @array
  end
end

class Guess
  attr_reader :array

  def initialize(guess_str)
    @array = guess_str.upcase.split("")
  end

  def str
    @array.join
  end
end

class Feedback
  attr_reader :array

  def initialize(length)
    @array = Array.new(length, "-")
  end

  def correct(idx)
    @array[idx] = "1"
  end

  def right_color(idx)
    @array[idx] = "0"
  end

  def wrong(idx)
    @array[idx] = "-"
  end

  def get_str
    @array.join
  end
end

class Game
  @@round = 1

  def initialize(turns, code_pegs, solution, colours)
    @turns = turns
    @code_pegs = code_pegs
    @solution = solution.array
    @colours = colours
    @computer = solution
  end

  def guessor
    puts "\nGuess by entering a combination of #{@code_pegs} colours."
    sleep 2
    puts "\n>> COLOURS: #{@colours.join(" ")}."
    puts ">> KEY: 1 = correct colour, correct position"
    puts ">>      0 = correct colour, wrong position"
    puts ">>      - = wrong colour, wrong position\n\n"
    sleep 1
    while @@round <= @turns
      puts "---------------------------------------------"
      sleep 1
      puts "ROUND #{@@round} / #{@turns}   #{@colours.join(" ")}"
      player_guess = self.get_guess
      feedback_str = self.give_feedback(player_guess)
      if @@round == @turns
        puts "Oh no, you ran out of guesses before you could crack the code :("
        break
      elsif self.win?(feedback_str)
        puts "CONGRATULATIONS, mastermind! You've cracked the code: #{@solution.join}"
        break
      else
        @@round += 1
      end
    end
  end

  def creator
    while @@round <= @turns
      puts "---------------------------------------------"
      sleep 1
      puts "ROUND #{@@round} / #{@turns}\n\n"
      sleep 1
      computer_guess = @computer.create_guess
      puts "      GUESS: #{computer_guess.join}\n\n"
      sleep 1
      puts "Please give me some feedback!\n\n"
      sleep 1
      puts ">> KEY: 1 = correct colour, correct position"
      puts ">>      0 = correct colour, wrong position"
      puts ">>      - = wrong colour, wrong position\n\n"
      feedback_arr = self.get_feedback
      if self.win?(feedback_arr.join)
        puts "I've cracked your code! It's #{computer_guess.join}!"
        break
      end
      @solution = @computer.update_solution(feedback_arr, computer_guess)
      @@round += 1
    end
  end

  protected
  def get_guess
    print "\n      GUESS: "
    input = gets.chomp
    while check_guess(input) == false
      print "\n      GUESS: "
      input = gets.chomp
    end
    return Guess.new(input).array
  end

  def check_guess(input)
    if input.length != @code_pegs
      puts "Please guess with a combination of #{@code_pegs} colours!"
      return false
    elsif (input.upcase.split("") & @colours).empty?
      puts "Please input valid colours from #{@colours.join(" ")}."
      return false
    else
      return true
    end
  end

  def test_guess(guess)
    feedback = Feedback.new(@code_pegs)
    guess.each_with_index do |letter, idx|
      if letter == @solution[idx]
        feedback.correct(idx)
      elsif @solution.include?(letter) && guess.count(letter) <= @solution.count(letter)
        feedback.right_color(idx)
      else
        feedback.wrong(idx)
      end
    end
    return feedback
  end

  def give_feedback(guess)
    feedback = self.test_guess(guess)
    str = feedback.get_str
    sleep 1
    puts "   FEEDBACK: #{str} \n\n"
    sleep 1
    return str
  end

  def win?(str)
    (str == "1"*@code_pegs)? true : false
  end

  def get_feedback
    print "   FEEDBACK: "
    while feedback = gets.chomp
      feedback_arr = feedback.split("")
      key_arr = ['1', '0', '-']
      if feedback.length == @code_pegs && feedback_arr.all? {|x| key_arr.include?(x)}
        return feedback_arr
        break
      else
        puts "\nPlease use the feeback key!"
        print "   FEEDBACK: "
      end
    end
  end

end

class Home

  def initialize
    @colours = ["R", "W", "B", "G", "Y", "P"]
  end

  def start
    puts "Welcome to MASTERMIND"
    sleep 1
    print "Type '1' to guess the code, type '2' to create the code: "
    input = gets.chomp
    loop do
      if input == "1"
        puts "I have created a secret code..."
        sleep 2
        puts "Can you solve it before you run out of guesses?"
        sleep 2
        game = Game.new(12, 4, RandomSolution.new(4, @colours), @colours)
        game.guessor
        break
      elsif input == "2"
        puts "Create a secret code for me to guess from these colours: #{@colours.join(" ")}."
        sleep 2
        print "Please enter the length of your code: "
        while length = gets.chomp
          if length == length.to_i.to_s
            length = length.to_i
            break
          else
            print "Please enter the length of your code: "
          end
        end
        game = Game.new(12, length, ComputerPlayer.new(length, @colours), @colours)
        game.creator
        break
      else
        print "Please choose from the options: "
        input = gets.chomp
      end
    end
  end
end

x = Home.new
x.start