require_relative "game_piece"
require_relative "chess_board"


class Player
  attr_accessor :colour, :checked

  def initialize(colour)
    @colour = colour
    @checked = false
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
    # Intro
    puts ">>>>> C H E S S <<<<<"
    puts "Select game pieces and squares using letters and numbers, e.g. 'b5'."
    puts "Note: once you touch a piece, you must move it!"
    loop do
      # Show the chess board
      @board.show

      # Determime current player
      current_player = (@turn.odd?)? @player_w : @player_b
      puts "#{current_player.colour.upcase}'S MOVE"

      # if in check, current player must move king
      if current_player.checked
        old_loc = @board.find_king(current_player.colour)
        puts "Move piece: "
        puts "You're in check, you must move the king!"
      end

      # Get player's choice and check validity of choice
      old_loc = loop do
        print "Move piece: "
        old_loc = gets.chomp.downcase
        break old_loc if self.valid_choice?(old_loc, current_player.colour)
        puts "That's not a valid choice!"
      end

      # Select game piece
      game_piece = @board.get(old_loc)

      # Mate?
      if game_piece.type == "king"
        if self.mate?(old_loc, game_piece)
          puts "CHECKMATE!"
        end
      end

      # Get player's selection and check validity of selection
      new_loc = loop do
        print "Move to: "
        new_loc = gets.chomp.downcase
        break new_loc if valid_move?(old_loc, new_loc, game_piece)
        puts "That's not a valid choice!"
      end

      # Move game piece
      @board.move_piece(old_loc, new_loc)
      game_piece.moved = true

      # If checked, remove check
      if current_player.checked
        current_player.checked = false
      end

      # Check check condition
      self.check?(new_loc, game_piece)
      
      # Increment turn
      @turn += 1

    end
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

  def valid_move?(old_loc, new_loc, game_piece)
    # Check input format
    if !self.valid_input?(old_loc)
      return false

    # Check if new square is occupied. If yes, check not same team as self
    elsif !@board.empty?(new_loc)
      return false if @board.get(new_loc).colour == game_piece.colour
    end

    # Switch statements for each game piece type
    case game_piece.type
    when "rook"
      self.rook_moves?(old_loc, new_loc)
    when "pawn"
      self.pawn_moves?(old_loc, new_loc, game_piece)
    when "bishop"
      self.bishop_moves?(old_loc, new_loc)
    when "queen"
      self.queen_moves?(old_loc, new_loc)
    when "knight"
      self.knight_moves?(old_loc, new_loc)
    when "king"
      self.king_moves?(old_loc, new_loc, game_piece)
    end
  end

  def valid_input?(input)
    if input.length == 2 && ("a".."z").include?(input[0]) && ("1".."8").include?(input[1])
      return true
    else
      return false
    end
  end

  def rook_moves?(old_loc, new_loc)
    x, y, new_x, new_y = old_loc[0], old_loc[1].to_i, new_loc[0], new_loc[1].to_i
    # vertical movement, check spaces between are empty
    if x == new_x
      range = (new_y > y)? Array(y+1...new_y) : Array(new_y+1...y)
      range.each do |num|
        return false if !@board.empty?("#{x}#{num}")
      end
      return true
    # horizontal movement, check spaces between are empty
    elsif y == new_y
      range = (new_x > x)? Array(x...new_x) - [x] : Array(new_x...x) - [new_x]
      range.each do |num|
        return false if !@board.empty?("#{y}#{num}")
      end
      return true
    else
      return false
    end
  end

  def bishop_moves?(old_loc, new_loc)
    x, y, new_x, new_y = old_loc[0], old_loc[1].to_i, new_loc[0], new_loc[1].to_i
    # diagonal right, upwards movement
    if new_x > x && new_y > y
      moves = (x..new_x).zip(y..new_y).map{|arr| arr.join}
    # diagonal left, downwards movement
    elsif new_x < x && new_y < y
      moves = (new_x..x).zip(new_y..y).map{|arr| arr.join}
    # diagonal right, downwards movement
    elsif new_x > x && new_y < y
      moves = (x..new_x).zip(Array(new_y..y).reverse).map{|arr| arr.join}
    # diagonal left, upwards movement
    elsif new_x < x && new_y > y
      moves = (Array(new_x..x).reverse).zip(y..new_y).map{|arr| arr.join}
    else
      return false
    end

    if moves.length > 2 && (moves[1..-2]).any?{|loc| !@board.empty?(loc)}
      return false
    elsif !moves.include?(new_loc)
      return false
    else
      return true
    end
    # diagonal down movement, check spaces between are empty
  end

  def pawn_moves?(old_loc, new_loc, game_piece)
    x, y, new_x, new_y = old_loc[0], old_loc[1].to_i, new_loc[0], new_loc[1].to_i
    # check not moving backwards
    if game_piece.colour == "white"
      return false if new_y < y
    else
      return false if y < new_y
    end

    # check if moving to an empty square or occupied square
    if @board.empty?(new_loc) # empty square
      if x != new_x || # non-vertical movement
        (game_piece.moved && (new_y - y == 2)) || # moving a moved piece more than 1 space
        (new_y - y > 2) # moving more than 2 spaces
        ((new_y - y == 2) && !@board.empty?("#{x}#{y+1}")) # jumping over a piece
        return false
      else
        return true
      end
    else # not empty square
      x_arr = (new_x > x)? (x..new_x).to_a : (new_x..x).to_a
      if (new_y - y).abs != 1 || x_arr.length != 2
        return false
      else
        return true
      end
    end
  end

  def knight_moves?(old_loc, new_loc)
    nl = Hash[("a".."h").zip(1..8)]
    x, y, new_x, new_y = nl[old_loc[0]], old_loc[1].to_i, new_loc[0], new_loc[1].to_i
    finish = []
    moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
    moves.each do |move|
      j = x + move[0]
      k = y + move[1]
      finish << [j, k] if [j, k].all? {|l| l < 9 && l > 0}
    end
    return (finish.include?([nl[new_x], new_y]))? true : false
    
  end

  def queen_moves?(old_loc, new_loc)
    (self.rook_moves?(old_loc, new_loc))? true : (self.bishop_moves?(old_loc, new_loc))? true : false
  end

  def king_moves?(old_loc, new_loc, game_piece)
    x, y, new_x, new_y = old_loc[0], old_loc[1].to_i, new_loc[0], new_loc[1].to_i
    x_arr = (new_x > x)? (x...new_x).to_a : (new_x...x).to_a

    # check if only one square is moved
    return false if !((y - new_y).abs < 2 && x_arr.length < 2)

    # cannot move into check; check if in checked position
    # select all opponent pieces, see if any of them can make a valid move to the king's new_loc
    enemy_pieces = (@board.board).select {|k,v| v && v.colour != game_piece.colour}
    enemy_pieces.each do |pos, piece|
      if self.valid_move?(pos, new_loc, piece)
        return false
      end
    end
    return true
  end

  def check?(new_loc, game_piece)
    opp = (game_piece.colour == "black")? @player_w : @player_w
    opp_king_pos = @board.find_king(opp.colour)
    # get the opponent king's position, and check if the game piece being moved and move to the king's position    
    if self.valid_move?(new_loc, opp_king_pos, game_piece)
      puts "CHECK!"
      opp.checked = true
    else
      return false
    end
  end

  # Returns false if there is a valid move a king could move; else true if there is no valid move left
  def mated?(old_loc, game_piece)
    x, y = old_loc[0], old_loc[1].to_i
    x_arr = ("a".."h").to_a
    x_idx = x_arr.index(x)
    kings_moves = ((x_arr[x_idx-1..x_idx+1]).product((y-1..y+1).to_a)).map {|arr| arr.join} - [old_loc]
    kings_moves.each do |loc|
      return false if self.valid_move?(old_loc, loc, game_piece)
    end
    return true
  end

end

chess = Chess.new
chess.play