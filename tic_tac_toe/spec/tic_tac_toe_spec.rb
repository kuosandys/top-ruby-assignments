require './lib/tic_tac_toe.rb'

describe Game do

  describe "#win?" do
    it "accepts horizontal victory" do
      player_1 = Player.new("Alex")
      player_2 = Player.new("Bob")
      game = Game.new(player_1, player_2)    
      game.marks = {player_1 => [], player_2 => [0, 1, 2]}
      expect(game.win?(player_2)).to eql(true)
    end

    it "accepts vertical victory" do
      player_1 = Player.new("Alex")
      player_2 = Player.new("Bob")
      game = Game.new(player_1, player_2)    
      game.marks = {player_1 => [], player_2 => [0, 3, 6]}
      expect(game.win?(player_2)).to eql(true)
    end

    it "accepts diagonal victory" do
      player_1 = Player.new("Alex")
      player_2 = Player.new("Bob")
      game = Game.new(player_1, player_2)    
      game.marks = {player_1 => [], player_2 => [0, 4, 8]}
      expect(game.win?(player_2)).to eql(true)
    end
  end

  
end