require './lib/chess.rb'

describe Board do
  it "creates a hash object to represent the squares" do
    board = Board.new
    expect(board.board).to be_kind_of(Hash)
  end

  it "creates a squares of 64 squares" do
    board = Board.new
    expect(board.board.length).to eql(64)
  end

  it "stores each square's coord as key 'letter+number' with init value nil" do
    board = Board.new
    expect(board.board["g6"]).to eql(nil)
  end

  it "puts game pieces at their starting positions on initialization" do
    board = Board.new
    expect(board.board["a2"]).to be_kind_of(Piece)
  end

  describe "#get" do
    it "returns the game piece on the location given, nil if empty" do
      board = Board.new
      expect(board.get("c2")).to be_kind_of(Piece)
      expect(board.get("b3")).to eql(nil)
    end
  end

  describe "#empty?" do
    it "returns true if the square is empty, else false" do
      board = Board.new
      expect(board.empty?("f2")).to eql(false)
      expect(board.empty?("g3")).to eql(true)
    end
  end

  describe "#move_piece" do
    it "moves a piece from the old location to the new location" do
      board = Board.new
      game_piece = board.get("a2")
      board.move_piece("a2", "a3")
      expect(board.empty?("a2")).to eql(true)
      expect(board.get("a3")).to eql(game_piece)
    end

    it "takes another piece when the move is valid" do
      board = Board.new
      game_piece = board.add_piece("a3", "black", "rook")
      taken_piece = board.get("a2")
      board.move_piece("a3", "a2")
      expect(board.get("a2")).to eql(game_piece)
      expect(board.empty?("a3")).to eql(true)
      expect(board.offboard).to eql([taken_piece])
    end

    it "changes the @mvoed attribute of the piece after being moved" do
      board = Board.new
      game_piece = board.get("b2")
      expect(game_piece.moved).to eql(false)
      board.move_piece("b2", "c2")
      expect(game_piece.moved).to eql(true)
    end
  end

  describe "#find_king" do
    it "returns the locatino of the king from its colour and type" do
      board = Board.new
      expect(board.find_king("white")).to eql("e1")
    end
  end

end

describe Chess do

  describe "#valid_input?" do
    it "checks if the player has made a valid input" do
      chess = Chess.new
      expect(chess.valid_input?("asdf")).to eql(false)
      expect(chess.valid_input?("b7")).to eql(true)
    end
  end

  describe "#valid_choice?" do
    it "checks if the player has chosen its own game piece to move" do
      chess = Chess.new
      expect(chess.valid_choice?("a1", "white")).to eql(true)
      expect(chess.valid_choice?("a8", "white")).to eql(false)
    end

    it "checks that the player has not selected an empty square" do
      chess = Chess.new
      expect(chess.valid_choice?("a3", "white")).to eql(false)
    end
  end

  describe "#valid_move?" do
  end

  describe "#pawn_moves?" do
    it "allows the first piece to move 2 spaces forward" do
      chess = Chess.new
      board = chess.board
      expect(chess.pawn_moves?("a2", "a4", board.get("a2"))).to eql(true)
    end

    it "allows any piece to move forward 1 space" do
      chess = Chess.new
      board = chess.board
      expect(chess.pawn_moves?("d2", "d3", board.get("d2"))).to eql(true)
    end

    it "does not allow any other movement" do
      chess = Chess.new
      board = chess.board
      expect(chess.pawn_moves?("d2", "f5", board.get("d2"))).to eql(false)
    end

    it "takes an enemy piece diagonally" do
      chess = Chess.new
      board = chess.board
      new_piece = board.add_piece("e3", "black", "rook")
      expect(chess.pawn_moves?("d2", "e3", board.get("d2"))).to eql(true)
      board.move_piece("d2", "e3")
      expect(board.get("e3").type).to eql("pawn")
    end

    it "does not allow backwards movement" do
      chess = Chess.new
      board = chess.board
      board.add_piece("e4", "black", "pawn")
      expect(chess.pawn_moves?("e4", "e5", board.get("e4"))).to eql(false)
    end
  end

  describe "#rook_moves?" do
    it "allows vertical movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.rook_moves?("a4", "a6")).to eql(true)
    end

    it "allows horizontal movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.rook_moves?("a4", "c4")).to eql(true)\
    end

    it "does not allow any other movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.rook_moves?("a4", "b6")).to eql(false)
    end

    it "does not allow the movement if the squares in between are occupied" do
      chess = Chess.new
      expect(chess.rook_moves?("a1", "a4")).to eql(false)
    end
  end

  describe "#bishop_moves?" do
    it "allows diagonal movement towards top right" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a3", "white", "bishop")
      expect(chess.bishop_moves?("a3", "c5")).to eql(true)
    end

    it "allows diagonal movement towards bottom left" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("c5", "white", "bishop")
      expect(chess.bishop_moves?("c5", "a3")).to eql(true)
    end

    it "allows diagonal movement towards bottom right" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("c5", "white", "bishop")
      expect(chess.bishop_moves?("c5", "e3")).to eql(true)
    end

    it "allows diagonal movement towards top left" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("e3", "white", "bishop")
      expect(chess.bishop_moves?("e3", "b6")).to eql(true)
    end

    it "does not allow the bishop to jump over occupied squares" do
      chess = Chess.new
      board = chess.board
      expect(chess.bishop_moves?("c1", "a3")).to eql(false)
    end

    it "does not allow non-diagonal movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a3", "white", "bishop")
      expect(chess.bishop_moves?("a3", "b5")).to eql(false)
    end
  end

  describe "#queen_moves?" do
    it "can move diagonally like a bishop" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a3", "black", "queen")
      expect(chess.queen_moves?("a3", "c5")).to eql(true)
    end

    it "can move horizontally like a rook" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a3", "black", "queen")
      expect(chess.queen_moves?("a3", "d3")).to eql(true)
    end

    it "can make step-wise movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "black", "queen")
      expect(chess.queen_moves?("a4", "a3")).to eql(true)
    end

    it "cannot make any other movement, e.g. like a knight" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a3", "black", "queen")
      expect(chess.queen_moves?("a3", "b5")).to eql(false)
    end
  end

  describe "#knight_moves?" do
    it "makes an L-shaped move like a knight" do
      chess = Chess.new
      board = chess.board
      expect(board.get("b1").type).to eql("knight")
      expect(chess.knight_moves?("b1", "c3")).to eql(true)
    end

    it "cannot make another kind of move, e.g. diagonal" do
      chess = Chess.new
      board = chess.board
      expect(board.get("b1").type).to eql("knight")
      expect(chess.knight_moves?("b1", "c4")).to eql(false)
    end
  end

  describe "#king_moves" do
    it "can move forward a square" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a5", "black", "king")
      expect(chess.king_moves?("a5", "a6", game_piece)).to eql(true)
    end

    it "can move diagonally back a square" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a5", "black", "king")
      expect(chess.king_moves?("a5", "b6", game_piece)).to eql(true)
    end

    it "cannot move more than one space at a time" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("b4", "black", "king")
      expect(chess.king_moves?("b4", "b6", game_piece)).to eql(false)
    end

    it "cannot move into check" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("b5", "black", "king")
      expect(chess.king_moves?("b5", "b4", game_piece)).to eql(false)
    end
  end

  describe "#check?" do
    it "returns true if the opponent king is in check" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("b4", "black", "queen")
      king = board.add_piece("b3", "white", "king")
      expect(chess.check?("b4", game_piece)).to eql(true)
    end

    it "returns false if the opponent king is not in check" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("c4", "black", "rook")
      king = board.add_piece("b3", "white", "king")
      expect(chess.check?("c4", game_piece)).to eql(false)
    end
  end

end