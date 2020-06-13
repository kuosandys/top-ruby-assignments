class LinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  # Adds new node of (value) to end of list
  def append(value)
    if @tail  #tail exists (list of size > 1)
      new_tail = Node.new(value)
      @tail.next_node = new_tail
      @tail = new_tail
    else #empty list
      @tail = Node.new(value)
      @head = @tail
    end
  end

  # Adds new node of (value) to beginning of list
  def prepend(value)
    if @head  #head exists (list of size > 1)
      new_head = Node.new(value, next_node=@head.next_node)
      @head = new_head
    else #empty list
      @head = Node.new(value)
      @tail = @head
    end
  end

  def size
    count = 0
    if @head || @tail
      current_node = @head
      while current_node.next_node
        current_node = current_node.next_node
        count += 1
      end
    end
    return count
  end

  def to_s
    current_node = @head
    loop do
      print "( #{current_node.value} ) -> "
      break if current_node.next_node == nil
      current_node = current_node.next_node
    end
    print "nil"
  end
  # def at(index)
  #   current_node = @head
  #   (index - 1).times do
  #     current_node = current_node.next_node
  #   end
  #   return current_node
  # end

end

class Node
  attr_accessor :value, :next_node
  def initialize(value=nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

new_list = LinkedList.new
new_list.prepend("y")
new_list.to_s