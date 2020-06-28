class Piece
  attr_accessor :colour, :type, :symbol

  def initialize(colour, type)
    @colour = colour
    @type = type
    @symbol = self.get_symbol(@colour, @type)
  end

  def get_symbol(colour, type)
    if colour == "white"
      symbol_hash = {
        "rook"=>"\u2656",
        "knight"=>"\u2658",
        "bishop"=>"\u2657",
        "king"=>"\u2654",
        "queen"=>"\u2655",
        "pawn"=>"\u2659"
      }
      return symbol_hash[type]
    else
      symbol_hash = {
        "rook"=>"\u265A",
        "knight"=>"\u265E",
        "bishop"=>"\u265D",
        "king"=>"\u265A",
        "queen"=>"\u265B",
        "pawn"=>"\u265F"
      }
      return symbol_hash[type]
    end
  end

end

class Player
  attr_accessor :colour

  def initialize(colour)
    @colour = colour
  end
end

class Board
  attr_accessor :board

  def initialize
    array = Array("a".."h").product(Array("1".."8")).map {|x| x.join}
    @board = Hash[array.map {|x| [x, nil]}]
    @board["a1"] = Piece.new("white", "rook")
    @board["h1"] = Piece.new("white", "rook")
    @board["b1"] = Piece.new("white", "knight")
    @board["g1"] = Piece.new("white", "knight")
    @board["c1"] = Piece.new("white", "bishop")
    @board["f1"] = Piece.new("white", "bishop")
    @board["e1"] = Piece.new("white", "king")
    @board["d1"] = Piece.new("white", "queen")
    ("a".."h").each do |x|
      @board["#{x}2"] = Piece.new("white", "pawn")
      @board["#{x}7"] = Piece.new("black", "pawn")
    end
    @board["a8"] = Piece.new("black", "rook")
    @board["h8"] = Piece.new("black", "rook")
    @board["b8"] = Piece.new("black", "knight")
    @board["g8"] = Piece.new("black", "knight")
    @board["c8"] = Piece.new("black", "bishop")
    @board["f8"] = Piece.new("black", "bishop")
    @board["e8"] = Piece.new("black", "king")
    @board["d8"] = Piece.new("black", "queen")
  end

  def get(loc)
    return @board[loc]
  end

  def empty?(loc)
    return (self.get(loc) == nil)? true : false
  end

  def move_piece(old_loc, new_loc)
    game_piece = self.get(old_loc)
    @board[new_loc] = game_piece
    @board[old_loc] = nil
  end

  def show
    puts "\n   a b c d e f g h   \n"
    (8).downto(1).each do |x|
      row = @board.select{|k,v| k.include?("#{x}")}
      puts "#{x}  #{row.map {|k, v| (v)? v.symbol : "x"}.join(" ")}  #{x}"
    end
    puts "   a b c d e f g h   \n\n"
  end

  def add_piece(loc, colour, type)
    @board[loc] = Piece.new(colour, type)
  end
end

class Chess
  attr_accessor :board

  def initialize
    @player_w = Player.new("white")
    @player_b = Player.new("black")
    @board = Board.new
    @turn = 1
  end

  def play
    puts ">>>>> C H E S S <<<<<"
    puts "Select game pieces and squares using letters and numbers, e.g. 'b5'."
    puts "Note: once you touch a piece, you must move it!"
    @board.show
    current_player = (@turn.odd?)? @player_w : @player_b
    puts "#{current_player.colour.upcase}'S MOVE"
    # choose a piece and check
    old_loc = loop do
      print "Move piece: "
      old_loc = gets.chomp.downcase
      break old_loc if self.valid_choice?(old_loc, current_player.colour)
      puts "That's not a valid choice!"
    end
    game_piece = @board.get(old_loc)
    new_loc = loop do
      print "Move to: "
      new_loc = gets.chomp.downcase
      break new_loc if valid_move?(old_loc, new_loc, game_piece.type)
      puts "That's not a valid choice!"
    end
    # check move is valid for piece type
    @board.move_piece(old_loc, new_loc)
  end

  def valid_choice?(old_loc, colour)
    if !self.valid_input?(old_loc)
      return false
    elsif @board.empty?(old_loc)  # Not selecting empty square
      return false
    elsif @board.get(old_loc).colour != colour # Selecting own pieces
      return false
    else
      return true
    end
  end

  def valid_move?(old_loc, new_loc, type)
    if !self.valid_input?(old_loc)
      return false
    end

    x = old_loc[0]
    y = old_loc[1].to_i
    new_x = new_loc[0]
    new_y = new_loc[1].to_i

    case type
    when "rook"
      # vertical movement, check spaces between are empty
      if x == new_x
        range = (new_y > y)? (y+1...new_y).to_a : (new_y+1...y).to_a
        range.each do |num|
          return false if !@board.empty?("#{x}#{num}")
        end
        return true
      # horizontal movement, check spaces between are empty
      elsif y == new_y
        range = (new_x > x)? (x...new_x).to_a - [x] : (new_x...x).to_a - [new_x]
        range.each do |num|
          return false if !@board.empty?("#{y}#{num}")
        end
        return true
      else
        return false
      end
    end
  end

  def valid_input?(input)
    if input.length == 2 && ("a".."z").include?(input[0]) && ("1".."7").include?(input[1])
      return true
    else
      return false
    end
  end
end

# Chess.new.play