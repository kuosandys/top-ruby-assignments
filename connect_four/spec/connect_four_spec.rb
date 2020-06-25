require './lib/connect_four.rb'

describe Player do
  it "creates a player with marker x" do
    player = Player.new("Alex")
    expect(player.marker).to eql("x")
  end

  it "creates a player with marker o" do
    player = Player.new("Bob")
    expect(player.marker).to eql("o")
  end
end

describe Game do

  describe "#get_players" do
    it "creates a player with marker x and a player with marker o" do
      game = Game.new
      game.get_players
      expect(game.player_1).to be_a(Player)
      expect(game.player_2).to be_a(Player)
    end
  end

  describe "#whose_turn?" do
    it "determines whose turn it is" do
      game = Game.new
      expect(game.whose_turn?).to eql(game.player_1)
      # col = game.get_column(4)
      # game.select_column(col)
      # expect(game.turn).to eql(game.player_2)
    end
  end

  describe "#display_board" do
    it "gets the board" do
      game = Game.new
      array = [
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "]
      ]
      expect(game.board).to eql(array)
    end

    it "prints the board" do
      game = Game.new
      game.board = [
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " "],
        [" ", "o", " ", " ", " ", " ", " "],
        [" ", "x", " ", " ", " ", " ", " "],
        ["o", "x", "o", " ", " ", "x", "o"]
      ]
      string =  " 1 2 3 4 5 6 7 \n"
      string += "| | | | | | | |\n"
      string += "| | | | | | | |\n"
      string += "| | | | | | | |\n"
      string += "| |o| | | | | |\n"
      string += "| |x| | | | | |\n"
      string += "|o|x|o| | |x|o|\n"
      expect(game.display_board).to eql(string)
    end
  end

  describe "#get_column" do
    it "gets the column from the player, returns appropriate index" do
      game = Game.new
      player_input = 4
      expect(game.get_column(4)).to eql(3)
    end

    it "returns nil if the player does not give a valid column" do
    game = Game.new
    player_input = 8
    expect(game.get_column(8)).to eql(nil)
    end
  end

  describe "#select_column" do
    it "drops to the bottom of an empty column" do
      game = Game.new
      game.select_column(3, "x")
      expect(game.board[5][2]).to eql("x")
    end

    it "drops to row 4 if row 5 is occupied" do
      game = Game.new
      2.times do
        game.select_column(3, "x")
      end
      expect(game.board[4][2]).to eql("x")
    end
  end

  describe "#column_full?" do
    it "returns true if column is full" do
      game = Game.new
      6.times do
        game.select_column(3, "x")
      end
      expect(game.column_full?(2)).to eql(true)
    end

    it "returns false if column is not full" do
      game = Game.new
      5.times do
        game.select_column(3, "x")
      end
      expect(game.column_full?(3)).to eql(false)
    end
  end

  describe "#win?" do
    it "returns false if no winner" do
      game = Game.new
      game.board = [
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", "x", " ", " ", " "],
    ["x", "o", "x", "o", " ", " ", " "]

      ]
      expect(game.win?("x")).to eql(false)
    end

    it "returns true if there is 4 in a row horizontal" do
      game = Game.new
      game.board = [
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", "o", "o", " "],
    [" ", " ", "x", "x", "x", "x", " "]
      ]
      expect(game.win?("x")).to eql(true)
    end

    it "returns true if there is 4 in a row vertical" do
      game = Game.new
      game.board = [
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    ["x", " ", " ", " ", " ", " ", " "],
    ["x", " ", " ", " ", " ", " ", " "],
    ["x", " ", " ", " ", " ", " ", " "],
    ["x", "o", "o", " ", " ", " ", " "]
      ]
      expect(game.win?("x")).to eql(true)
    end

    it "returns true if there is 4 in a row diagonal upwards" do
      game = Game.new
      game.board = [
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", "x", " ", " ", " "],
    [" ", " ", "x", "o", " ", " ", " "],
    [" ", "x", "o", "o", " ", " ", " "],
    ["x", "o", "o", "x", " ", " ", " "]
      ]
      expect(game.win?("x")).to eql(true)
    end

    it "returns true if there is 4 in a row diagonal downwards" do
      game = Game.new
      game.board = [
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", " ", " ", " ", " ", " "],
    [" ", " ", "o", " ", " ", " ", " "],
    [" ", " ", "x", "o", " ", " ", " "],
    [" ", "x", "o", "o", "o", " ", " "],
    ["x", "o", "o", "x", "x", "o", " "]
      ]
      expect(game.win?("o")).to eql(true)
    end

    describe "#tie?" do
      it "returns true if the board is full and no one has won" do
        game = Game.new
        game.board = [
          ["o", "x", "o", "x", "o", "o", "x"],
          ["x", "x", "o", "x", "o", "o", "x"],
          ["o", "x", "x", "o", "x", "x", "o"],
          ["o", "o", "x", "x", "o", "o", "x"],
          ["o", "x", "o", "o", "o", "x", "o"],
          ["x", "o", "o", "o", "x", "x", "o"]
        ]
        expect(game.tie?).to eql(true)
      end
    end
  end

end