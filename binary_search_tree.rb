class Node
  include Comparable
  attr_accessor :data, :left, :right
  
  def <=>(another)
    @data <=> another.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :arr

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = self.build_tree(@arr)
  end

  def build_tree(arr)
    if arr.empty?
      return nil
    elsif arr.length < 2
      return Node.new(arr[0])
    else
      mid = arr.length / 2
      root = Node.new(arr[mid])
      root.left = build_tree(arr[0..(mid - 1)])
      root.right = build_tree(arr[(mid + 1)..-1])
      return root
    end
  end

  def insert(value)
    new_node = Node.new(value)
    current_node = @root

    loop do
      case new_node <=> current_node
      when 1
        if !current_node.right
          current_node.right = new_node
          break
        else
          current_node = current_node.right
        end
      when -1
        if !current_node.left
          current_node.left = new_node
          break
        else
          current_node = current_node.left
        end
      end
    end
  end

  def delete(value)
    if !arr.include?(value)
      puts "The value is not in this tree."
      return nil
    else
      current_node = @root
      parent_node = nil
      value_node = Node.new(value)
      loop do
        case value_node <=> current_node
        when 1
          parent_node = current_node
          current_node = current_node.right
        when -1
          parent_node = current_node
          current_node = current_node.left
        when 0
          if !current_node.left && !current_node.right
            if parent_node.left == current_node
              parent_node.left = nil
            else
              parent_node.right = nil
            end
          elsif current_node.left && current_node.right
            successor = find_minimum(current_node.right)
            new_value = successor.data
            self.delete(successor.data)
            current_node.data = new_value
          else
            
          end
          break
        end
      end
    end
  end

  def find_minimum(current_node)
    while current_node.left
      current_node = current_node.left
    end
    return current_node
  end

  def find(value)
    if !arr.include?(value)
      puts "The value is not in this tree."
      return nil
    else
      current_node = @root
      test_node = Node.new(value)
      loop do
        case test_node <=> current_node
        when 1
          current_node = current_node.right
        when -1
          current_node = current_node.left
        when 0
          return current_node
          break
        end
      end
    end
  end

end

array = [7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array_2 = [3, 2, 4, 1, 6, 5, 7]
treee = Tree.new(array_2)
p treee.delete(3)
p treee.root
