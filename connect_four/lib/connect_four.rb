class Player
  attr_accessor :name, :marker
  @@count = 1

  def initialize(name)
    @name = name
    @marker = (@@count.odd?)? "x" : "o"
    @@count += 1
  end
end

class Game
  attr_accessor :player_1, :player_2, :board, :turn

  def initialize
    @player_1 = nil
    @player_2 = nil
    @board = [
      [" ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " "],
      [" ", " ", " ", " ", " ", " ", " "]
    ]
    @turn = 1
  end

  def play
    puts "--- Welcome to Connect 4 ---"
    puts "Get 4 in a row to win!"
    self.get_players
    loop do
      current_player = self.whose_turn?
      puts "\n#{current_player.name}, it's your turn!\n"
      self.display_board
      loop do
        print "Please select a column: "
        input = gets.chomp.to_i
        col = self.get_column(input)
        if col != nil
          x = self.select_column(col, current_player.marker)
          break if x != nil
        end
      end
      if win?(current_player.marker)
        self.display_board
        puts "#{current_player.name} wins!"
        break
      elsif tie?
        self.display_board
        puts "It's a tie!"
        break
      end
      @turn += 1
    end
  end

  def get_players
    print "Please enter player 1's name: "
    @player_1 = Player.new(gets.chomp)
    puts "Welcome, #{@player_1.name}. Your marker will be '#{@player_1.marker}'."
    print "Please enter player 2's name: "
    @player_2 = Player.new(gets.chomp)
    puts "Welcome, #{@player_2.name}. Your marker will be '#{@player_2.marker}'."
  end

  def whose_turn?
    return (@turn.odd?)? @player_1 : @player_2
  end

  def display_board
    string = " 1 2 3 4 5 6 7 \n"
    @board.each do |row|
      string += "|"
      string += row.join("|")
      string += "|\n"
    end
    puts string
  end

  def get_column(input)
    if input < 8 && input > -1
      return input - 1
    else
      return nil
    end
  end

  def select_column(col, marker)
    if !self.column_full?(col)
      @board.each_with_index do |row, idx|
        if row[col] != " "
          @board[idx-1][col] = marker
          return true
        elsif idx == 5 && row[col] == " "
          @board[idx][col] = marker
          return true
        end
      end
      return nil
    end
  end

  def column_full?(column)
    if @board[0][column] == " "
      return false
    else
      puts "Sorry, that column is full!"
      return true
    end
  end

  def win?(marker)
    #horizontal win
    @board.each do |row|
      return true if row.join("").include?(marker*4)
    end

    #vertical win
    (0..6).each do |i|
      string = ""
      @board.each do |row|
        string += row[i]
      end
      return true if string.include?(marker*4)
    end

    #diagonal upwards win
    # sub-boards:
    a1 = @board[0..3].each {|row| row = row[0..3]}
    b1 = @board[0..4].each {|row| row = row[0..4]}
    c1 = @board[0..5].each {|row| row = row[0..5]}
    d1 = @board[0..5].each {|row| row = row[1..6]}
    e1 = @board[1..5].each {|row| row = row[2..6]}
    f1 = @board[2..5].each {|row| row = row[3..6]}
    sub_boards_1 = [a1, b1, c1, d1, e1, f1]
    sub_strings_1 = sub_boards_1.reduce([]) do |array, board|
      string = ""
      board.each_with_index.map {|row, i| string += board[i][board.length-1- i]}
      array << string
    end
    return true if sub_strings_1.any? {|str| str.include?(marker*4)}

    #diagonal downwards win
    # sub-boards:
    a2 = @board[2..5].each {|row| row = row[0..3]}
    b2 = @board[1..5].each {|row| row = row[0..4]}
    c2 = @board[0..5].each {|row| row = row[0..5]}
    d2 = @board[0..5].each {|row| row = row[1..6]}
    e2 = @board[0..4].each {|row| row = row[2..6]}
    f2 = @board[0..3].each {|row| row = row[3..6]}
    sub_boards_2 = [a2, b2, c2, d2, e2, f2]
    sub_strings_2 = sub_boards_2.reduce([]) do |array, board|
      string = ""
      board.each_with_index.map {|row, i| string += board[i][i]}
      array << string
    end
    return true if sub_strings_2.any? {|str| str.include?(marker*4)}

    return false
  end

  def tie?
    board_slots = @board.reduce([]) do |array,row|
      array << row.select{|i| i != " "}
    end
    return true if board_slots.all? {|row| row.length == 7}
    return false
  end

end

game = Game.new
game.play