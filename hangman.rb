require "json"

# 1. Choose a random word for the solution from 5desk.txt
def get_secret_word(file)
  # Load in 5desk.txt
  f = File.open(file, 'r') do |f|
    # Convert f object to array
    f_arr = f.to_a
    loop do
      # Generate random number between 0 and 61405 (length-1)
      rand_num = rand(0..f_arr.length-1)
      # Select word associated with random number from 5desk.txt
      word = f_arr[rand_num].chomp.downcase
      # Keep doing this until the word is between 5 and 12 characters long
      return word.split("") if word.length > 4 && word.length < 13
    end
  end
end

class Hangman
  def initialize(num_guesses, secret_word, word_play, incorrect_guesses, incorrect_letters, correct_letters)
    @num_guesses = num_guesses
    @secret_word = secret_word
    @word_play = word_play
    @incorrect_guesses = incorrect_guesses
    @incorrect_letters = incorrect_letters
    @correct_letters = correct_letters # to keep track of what has already been guessed
  end

  def play
    while @incorrect_guesses < @num_guesses
      self.display_game
      guess = self.get_guess
      if guess == "save"
        self.save_game
        break
      end
      self.test_guess(guess)
      break if winlose?
    end
  end

  protected

  # display game: guessed letters, incorrect guesses, incorrect letters
  def display_game
    puts "\n#{@word_play.join(" ")}\n\n"
    sleep 1
    puts "Incorrect guesses: #{@incorrect_guesses} / #{@num_guesses}"
    puts "Incorrect letters: #{@incorrect_letters.join(" ")}"
  end

  # Get a guess from the player, returns guessed letter
  def get_guess
    print "\nGUESS A LETTER or TYPE 'save' TO save: "
    while guess = gets.chomp.downcase
      if (guess.length == 1 && guess.match(/[a-z]/)) || guess == "save"
        return guess
      end
      puts "That's not a valid guess!"
      print "GUESS A LETTER: "
    end
  end

  # Test the guess
  def test_guess(guess)
    sleep 1
    # If the letter is in correct_letters, remind player it has already been guessed
    if @correct_letters.include?(guess)
      puts ">> You've already guessed that letter before!"
    # If the letter is in the word, update word_play, correct_letters
    elsif @secret_word.include?(guess)
      puts ">> Correct!"
      @correct_letters.push(guess)
      @secret_word.each_with_index do |letter, idx|
        if letter == guess
          @word_play[idx] = guess
        end
      end
    # If the letter is not in the word, update incorrect letters, incorrect guesses
    else
      puts ">> Sorry, try again!"
      if !@incorrect_letters.include?(guess)
        @incorrect_letters.push(guess)
      end
      @incorrect_guesses += 1
    end
  end

  def winlose?
    if @word_play == @secret_word
      puts "You've guessed it: #{@secret_word.join.upcase}! The man walks free thanks to you!"
      return true
    elsif @incorrect_guesses == @num_guesses
      puts "Oh no! You've run out of guesses and the poor man is walking to the gallows..."
      return true
    else
      return false
    end
  end

  def save_game
    # Create a hash with current arguments
    game = {
      'num_guesses' => @num_guesses, 
      'secret_word' => @secret_word, 
      'word_play' => @word_play, 
      'incorrect_guesses' => @incorrect_guesses, 
      'incorrect_letters' => @incorrect_letters, 
      'correct_letters' => @correct_letters
    }.to_json
    # Create a new JSON file and save the hash in .json format
    File.open('save.json', 'w') {|f| f.puts(game)}
  end
end

class Game
  def self.start
    puts "HANGMAN!"
    sleep 1
    print "Press 'n' for a new game. Press 'o' to play from last save: "
    while input = gets.chomp.downcase
      if input == 'n'
        secret_word = get_secret_word('5desk.txt')
        @game = Hangman.new(
          10, 
          secret_word, 
          Array.new(secret_word.length, '_'), 
          0, 
          [], 
          []
        )
        break
      elsif input == 'o'
        file = 'save.json'
        if File.file?('save.json')
          data = self.load_save(file)
          @game = Hangman.new(
            data['num_guesses'],
            data['secret_word'],
            data['word_play'],
            data['incorrect_guesses'],
            data['incorrect_letters'],
            data['correct_letters']
          )
          break
        else
          print "No game save to load! "
        end
      end
      print "Press 'n' for a new game. Press 'o' to play from last save: "
    end
    @game.play
  end

  def self.load_save(file)
    File.open(file, 'r') {|file| JSON.load(file)}
  end

end

Game.start