class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
  
  def <=>(another)
    @data <=> another.data
  end

end

class Tree
  attr_accessor :root, :arr

  def initialize(arr)
    @arr = arr.uniq.sort
    @root = self.build_tree(@arr)
  end

  def build_tree(arr)
    if arr.size < 1 # Start & finish overlap -> exit
      return nil
    elsif arr.size == 1 # Create a leaf node
      Node.new(arr[0])
    else # Recursively divide the array into 2 and make subtrees
      midpoint = arr.length / 2
      root = Node.new(arr[midpoint])
      root.left = build_tree(arr[0..midpoint-1])
      root.right = build_tree(arr[midpoint+1..-1])
      return root
    end
  end

  def insert(value)
    # Create the node
    new_node = Node.new(value)

    # Loop through the tree until a leaf node is found -> insert
    current_node = @root
    loop do
      case new_node <=> current_node
      when 1 # Greater than current node
        if !current_node.right # Leaf node
          current_node.right = new_node
          break
        else # Keep going
          current_node = current_node.right
        end
      when -1 # Less than current node
        if !current_node.left # Leaf node
          current_node.left = new_node
          break
        else # Keep going
          current_node = current_node.left
        end
      when 0 # Node exists
        break
      end
    end
    
  end

  def delete(value)
    current_node = @root
    parent_node = nil

    # First find the node
    loop do
      case Node.new(value) <=> current_node
      when 1 # Greater than current node -> go right
        parent_node = current_node
        current_node = current_node.right
      when -1 # Less than current node -> go left
        parent_node = current_node
        current_node = current_node.left
      when 0 # Found the node
        # Case 1: node has no children
        if !current_node.left && !current_node.right
          # delete node
          if parent_node.left == current_node
            parent_node.left = nil
          else
            parent_node.right = nil
          end
          break
          
        # Case 2: node has two children (subtrees) 
        elsif current_node.left && current_node.right
          # find the maximum of the left subtree (successor)
          successor = current_node.left
          while successor.right
            successor = successor.right
          end
          successor_value = successor.data
          # recursively delete the successor node
          self.delete(successor.data)
          # and replace the current node with its value
          current_node.data = successor_value
          break

        # Case 3: node has one child
        else
          child = (current_node.left)? current_node.left : current_node.right
          # replace node with child
          if parent_node.left == current_node
            parent_node.left = child
          else
            parent_node.right = child
          end
          break
        end
      end
    end
  end

  def find(value)
    current_node = @root
    while current_node
      case Node.new(value) <=> current_node
      when -1
        current_node = current_node.left
      when 1
        current_node = current_node.right
      when 0
        return current_node
      end
    end
    return "The value is not in the tree"
  end

  def level_order(node=@root)
    queue = [node]
    i = 0
    while i < queue.length
      yield queue[i] if block_given?
      if queue[i].left then queue.push(queue[i].left) end
      if queue[i].right then queue.push(queue[i].right) end
      i += 1
    end
    return queue.map {|node| node.data}
  end

  def inorder(current_node=@root) #left, data, right
    array = (array)? array : []
    if !current_node
      return nil
    else
      self.inorder(current_node.left) {|x| if block_given? then yield x else array.push(x) end}
      if block_given? then yield current_node else array.push(current_node) end
      self.inorder(current_node.right) {|x| if block_given? then yield x else array.push(x) end}
    end
    return array.map {|node| node.data}
  end

  def preorder(current_node=@root) #data, left, right
    array = (array)? array : []
    if !current_node
      return nil
    else
      if block_given? then yield current_node else array.push(current_node) end
      self.preorder(current_node.right) {|x| if block_given? then yield x else array.push(x) end}
      self.preorder(current_node.left) {|x| if block_given? then yield x else array.push(x) end}
    end
    return array.map {|node| node.data}
  end

  def postorder(current_node=@root) #left, right, data
    array = (array)? array : []
    if !current_node
      return nil
    else
      self.postorder(current_node.left) {|x| if block_given? then yield x else array.push(x) end}
      self.postorder(current_node.right) {|x| if block_given? then yield x else array.push(x) end}
      if block_given? then yield current_node else array.push(current_node) end
    end
    return array.map {|node| node.data}
  end
  
  def depth(node)
    current_node = node
    if !current_node
      return 0
    else
      left_depth = self.depth(current_node.left)
      right_depth = self.depth(current_node.right)
    end
    return (left_depth > right_depth)? (left_depth + 1) : (right_depth + 1)
  end

  def balanced?
    # calculate depth of subtrees
    left_depth = depth(@root.left)
    right_depth = depth(@root.right)
    return ((left_depth - right_depth).abs < 2)? true : false
  end

  def rebalance!
    new_array = self.level_order(@root).reduce([]) {|arr, x| arr << x}
    @root = self.build_tree(new_array.sort)
  end

end

# 1. Create a binary search tree from an array of random numbers (`Array.new(15) { rand(1..100) }`)
ary = Array.new(15) {rand(1..100)}
tree = Tree.new(ary)
puts "Random array of numbers: #{ary}"
# 2. Confirm that the tree is balanced by calling `#balanced?`
puts "Is the tree balanced? #{tree.balanced?}"
# 3. Print out all elements in level, pre, post, and in order
puts "Level order #{tree.level_order}"
puts "Preorder #{tree.preorder}"
puts "Postorder #{tree.postorder}"
puts "Inorder #{tree.inorder}"
# 4. try to unbalance the tree by adding several numbers > 100
big_nums = Array.new(5) {rand(100..1000)}
big_nums.each {|num| tree.insert(num)}
puts "Adding big numbers: #{big_nums}"
# 5. Confirm that the tree is unbalanced by calling `#balanced?`
puts "Is the tree balanced? #{tree.balanced?}"
# 6. Balance the tree by calling `#rebalance!`
puts "Rebalancing..."
tree.rebalance!
# 7. Confirm that the tree is balanced by calling `#balanced?`
puts "Is the tree balanced? #{tree.balanced?}"
# 8. Print out all elements in level, pre, post, and in order
puts "Level order #{tree.level_order}"
puts "Preorder #{tree.preorder}"
puts "Postorder #{tree.postorder}"
puts "Inorder #{tree.inorder}"