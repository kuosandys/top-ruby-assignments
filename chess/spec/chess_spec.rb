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
      board.move_piece("a3", "a2")
      expect(board.get("a2")).to eql(game_piece)
      expect(board.empty?("a3")).to eql(true)
    end

    it "changes the @mvoed attribute of the piece after being moved" do
      board = Board.new
      game_piece = board.get("b2")
      expect(game_piece.moved).to eql(false)
      board.move_piece("b2", "c2")
      expect(game_piece.moved).to eql(true)
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
    # ROOK
    it "allows vertical movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "a6", game_piece)).to eql(true)
    end

    it "allows horizontal movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "c4", game_piece)).to eql(true)\
    end

    it "does not allow any other movement" do
      chess = Chess.new
      board = chess.board
      game_piece = board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "b6", game_piece)).to eql(false)
    end

    it "does not allow the movement if the squares in between are occupied" do
      chess = Chess.new
      board = chess.board
      expect(chess.valid_move?("a1", "a4", board.get("a1"))).to eql(false)
    end

    # PAWN
    it "allows the first piece to move 2 spaces forward" do
      chess = Chess.new
      board = chess.board
      expect(chess.valid_move?("a2", "a4", board.get("a2"))).to eql(true)
    end

    it "allows any piece to move forward 1 space" do
      chess = Chess.new
      board = chess.board
      expect(chess.valid_move?("d2", "d3", board.get("d2"))).to eql(true)
    end

    it "does not allow any other movement" do
      chess = Chess.new
      board = chess.board
      expect(chess.valid_move?("d2", "f5", board.get("d2"))).to eql(false)
    end

    it "takes an enemy pawn diagonally" do
      chess = Chess.new
      board = chess.board
      new_piece = board.add_piece("e3", "black", "rook")
      expect(chess.valid_move?("d2", "e3", board.get("d2"))).to eql(true)
      board.move_piece("d2", "e3")
      expect(board.get("e3").type).to eql("pawn")
    end
  end
end