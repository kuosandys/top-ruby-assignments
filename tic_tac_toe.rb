class Game

  def initialize(player_1, player_2)
    @player_1 = player_1
    @player_2 = player_2
    @board = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @turn = 0
    @marks = {player_1 => [], player_2 => []}
  end

  def self.start
    puts "--- Welcome to a game of Tic Tac Toe! ---"
    print ">> Please enter (x) Player 1's name: "
    name_1 = gets.chomp.upcase
    print ">> Please enter (o) Player 2's name: "
    name_2 = gets.chomp.upcase
    @game = Game.new(Player.new(name_1), Player.new(name_2))
    puts "Let's play, #{name_1} and #{name_2}!"
    sleep 1
    @game.play
  end

  def play
    self.show_board
    active = true
    while active
      current_player = ((@turn.even?)? @player_1 : @player_2)
      self.take_turn(current_player)
      self.show_board
      if self.win?(current_player)
        sleep 1
        puts "#{current_player.name} wins!"
        active = false
      elsif self.tie?
        puts "It's a tie!"
        active = false
      else
        @turn += 1
      end
    end
  end

  def show_board
    b = @board
    puts "-----------------------------------------"
    puts "               #{b[0]} | #{b[1]} | #{b[2]}"
    puts "              -----------"
    puts "               #{b[3]} | #{b[4]} | #{b[5]}"
    puts "              -----------"
    puts "               #{b[6]} | #{b[7]} | #{b[8]}"
    puts "-----------------------------------------\n"
  end

  protected

  def take_turn(player)
    puts "#{player.name}, it's your turn!"
    loop do
      print ">> Please make a selection by entering the number of a square: "
      selection = gets.chomp
      if selection.to_i.to_s != selection || !self.get_idx(selection)
        puts "That's not a valid selection!"
      elsif !self.get_idx(selection).is_a?(Integer)
        puts "That spot is already taken!"
      else
        self.make_mark(player, selection)
        break
      end
    end
  end

  def get_idx(selection)
    index = selection.to_i - 1
    (index < 9)? index : false
  end

  def make_mark(player, selection)
    square = self.get_idx(selection)
    marker = player.marker
    @marks[player] << square
    @board[square] = marker
  end

  def tie?
    @board.all?(/\D/)? true : false
  end

  def win?(player)
    player_arr = @marks[player]
    win_arr = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    win_arr.any? { |arr| arr.all? {|num| player_arr.include?(num)}}
  end
end

class Player
  attr_reader :name, :marker
  @@players = 0

  def initialize(name)
    @name = name
    @@players += 1
    @marker = (@@players.odd?)? "x" : "o"
  end
end

Game.start