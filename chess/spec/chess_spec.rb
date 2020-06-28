require './lib/chess.rb'
require './lib/rook.rb'

describe Board do
  board = Board.new
  it "creates a hash object to represent the squares" do
    expect(board.board).to be_kind_of(Hash)
  end

  it "creates a squares of 64 squares" do
    expect(board.board.length).to eql(64)
  end

  it "stores each square's coord as key 'letter+number' with init value nil" do
    expect(board.board["g6"]).to eql(nil)
  end

  it "puts game pieces at their starting positions on initialization" do
    expect(board.board["a2"]).to be_kind_of(Piece)
  end

  describe "#get" do
    it "returns the game piece on the location given, nil if empty" do
      expect(board.get("c2")).to be_kind_of(Piece)
      expect(board.get("b3")).to eql(nil)
    end
  end

  describe "#empty?" do
    it "returns true if the square is empty, else false" do
      expect(board.empty?("f2")).to eql(false)
      expect(board.empty?("g3")).to eql(true)
    end
  end

  describe "#move_piece" do
    it "moves a piece from the old location to the new location" do
      game_piece = board.get("a2")
      board.move_piece("a2", "a3")
      expect(board.empty?("a2")).to eql(true)
      expect(board.get("a3")).to eql(game_piece)
    end
  end
end

describe Chess do
  chess = Chess.new
  board = chess.board

  describe "#valid_input?" do
    it "checks if the player has made a valid input" do
      expect(chess.valid_input?("asdf")).to eql(false)
      expect(chess.valid_input?("b7")).to eql(true)
    end
  end

  describe "#valid_choice?" do
    it "checks if the player has chosen its own game piece to move" do
      expect(chess.valid_choice?("a1", "white")).to eql(true)
      expect(chess.valid_choice?("a8", "white")).to eql(false)
    end

    it "checks that the player has not selected an empty square" do
      expect(chess.valid_choice?("a3", "white")).to eql(false)
    end
  end

  describe "#valid_move?" do
    # ROOKS
    it "allows vertical movement" do
      board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "a6", "rook")).to eql(true)
    end

    it "allows horizontal movement" do
      board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "c4", "rook")).to eql(true)\
    end

    it "does not allow any other movement" do
      board.add_piece("a4", "white", "rook")
      expect(chess.valid_move?("a4", "b6", "rook")).to eql(false)
    end

    it "does not allow the movement if the squares in between are occupied" do
      expect(chess.valid_move?("a1", "a4", "rook")).to eql(false)
    end
  end
end