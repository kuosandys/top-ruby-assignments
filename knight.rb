class Knight
  attr_accessor :location, :moves, :parent

  def initialize(location)
    @location = location
    @moves = self.possible_moves(location)
    @parent = nil
  end

  def possible_moves(location, finish=[])
    moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
    moves.each do |move|
      x = location[0] + move[0]
      y = location[1] + move[1]
      finish << [x, y] if [x, y].all? {|xy| xy < 8 && xy > -1}
    end
    return finish
  end

end

def knight_moves(location, finish)
  queue = [Knight.new(location)]

  i = 0
  while i < queue.length
    current_knight = queue[i]
    if current_knight.location == finish #found
      path = []
      while current_knight #trace back parents
        path.unshift(current_knight.location)
        current_knight = current_knight.parent
      end
      puts "You made it in #{path.length - 1} moves! Here's your path:"
      path.each {|location| p location}
      return
    else
      current_knight.moves.each do |move|
        new_knight = Knight.new(move)
        new_knight.parent = current_knight
        queue.push(new_knight)
      end
    end
    i += 1
  end
end

puts knight_moves([3,3],[4,3])


