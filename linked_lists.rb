class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  # Adds new node of (value) to end of list
  def append(value)
    if @tail  # tail exists (list of size > 1)
      new_tail = Node.new(value)
      @tail.next_node = new_tail
      @tail = new_tail
    else # empty list
      @tail = Node.new(value)
      @head = @tail
    end
  end

  # Adds new node of (value) to beginning of list
  def prepend(value)
    if @head  # head exists (list of size > 1)
      new_head = Node.new(value, next_node=@head)
      @head = new_head
    else # empty list
      @head = Node.new(value)
      @tail = @head
    end
  end

  # Returns the total number of nodes in the list
  def size
    if @head # list is not empty
      count = 1 # the head node
      current_node = @head
      while current_node.next_node
        count += 1
        current_node = current_node.next_node
      end
      return count
    else # empty list
      return 0
    end
  end

# Returns node at (index)
def at(index)
  if (index < self.size) && (index > -1)
    current_node = @head
    (index).times do
      current_node = current_node.next_node
    end
    return current_node
  else
    return nil
  end
end

# Removes the last element from the list
def pop
  old_tail = @tail
  new_tail = self.at(self.size - 2) # find the second-to-last node
  new_tail.next_node = nil
  @tail = new_tail
  return old_tail # return the popped object
end

# Returns true if passed value is in the list, else false
def contains?(value)
  current_node = @head
  while current_node
    return true if current_node.value == value
    current_node = current_node.next_node
  end
  return false
end

# Returns index of node containing value, else returns nil
def find(value)
  length = self.size - 1
  (0..length).each do |idx|
    return idx if self.at(idx).value == value
  end
  return nil
end

# Inserts node with provided value at index
def insert_at(value, index)
  node_now = self.at(index)
  new_node = Node.new(value, node_now)
  self.at(index - 1).next_node = new_node
end

# Remove node at given index
def remove_at(index)
  self.at(index - 1).next_node = self.at(index + 1)
end

# Represents LinkedList objects as strings
  def to_s
    string = ""
    current_node = @head
    loop do
      string += "( #{current_node.value} ) -> "
      break if current_node.next_node == nil
      current_node = current_node.next_node
    end
    string += "nil"
    return string
  end

end

class Node
  attr_accessor :value, :next_node
  def initialize(value=nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end