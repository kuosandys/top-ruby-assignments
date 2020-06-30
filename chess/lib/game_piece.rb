class Piece
  attr_accessor :colour, :type, :symbol, :moved

  def initialize(colour, type)
    @colour = colour
    @type = type
    @symbol = self.get_symbol(@colour, @type)
    @moved = false
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
        "rook"=>"\u265C",
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