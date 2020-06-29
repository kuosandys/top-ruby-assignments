require_relative "game_piece.rb"

class Board
  attr_accessor :board, :offboard

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

    @offboard = []
  end

  def get(loc)
    return @board[loc]
  end

  def empty?(loc)
    return (self.get(loc) == nil)? true : false
  end

  def move_piece(old_loc, new_loc)
    game_piece = self.get(old_loc)
    @offboard << self.get(new_loc) if self.get(new_loc)
    @board[new_loc] = game_piece
    game_piece.moved = true
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
    return @board[loc]
  end

  def find_king(colour)
    @board.select{|k, v| v && v.colour == colour && v.type == "king"}.keys[0]
  end
end