require_relative "node"

class Tree

  attr_accessor :root, :data

  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    return nil if array.empty?

    # get the middle element and make it root
    mid = array.size / 2
    root = Node.new(array[mid])

    #construct the left subtree and make it left child of root
    root.left = build_tree(array[0...mid])

    #construct the right subtree and make it right child of root
    root.right = build_tree(array[mid + 1..-1])

    #return the level-0 root node
    root
  end

  def find(root = @root, value)
    return root if root.nil? || root.data == value

    if root.data < value
      return find(root.right, value)
    end
    return find(root.left, value)
  end

  def insert(root = @root, value)
    return Node.new(value) if root.nil? 
    if root.data == value
      return root
    elsif root.data < value
      root.right = insert(root.right, value)
    else
      root.left = insert(root.left, value)
    end
    return root
  end

  def min_value_node(node)
    current = node
    while !current.left.nil? 
      current = current.left
    end
   return current 
  end

  def delete(root = @root, value)
    return root if root.nil?
    
    if value < root.data 
      root.left = delete(root.left, value)
    elsif value > root.data
      root.right = delete(root.right, value)
    else
      # Node with only one child or no child
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      
      elsif root.right.nil? 
        temp = root.left
        root = nil
        return temp
      end
      # Node with two children:
      temp = min_value_node(root.right)
      root.data = temp.data
      root.right = delete(root.right, temp.data)
   end
    return root
  end

  #returns an array of values in breadth-first level order
  def level_order(root = @root)
    return if root.nil?
    array = []
    queue = []
    queue.unshift(root)
    until queue.empty?
      current = queue.last
      array << current.data
      queue.unshift current.left unless current.left.nil?
      queue.unshift current.right unless current.right.nil?
      queue.pop
    end
    return array
  end

  def preorder(root = @root, arr = [])
    return if root.nil?
    arr << root.data
    preorder(root.left, arr)
    preorder(root.right, arr)
    return arr
  end

  def inorder(root = @root, arr =[])
    return if root.nil?
    inorder(root.left, arr)
    arr << root.data
    inorder(root.right, arr)
    return arr
  end

  def postorder(root = @root, arr = [])
    return if root.nil?
    postorder(root.left, arr)
    postorder(root.right, arr)
    arr << root.data
    return arr
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def height(root = @root)
    return -1 if root.nil? 
    return [height(root.left), height(root.right)].max + 1
  end

  def depth(root = @root, parent = @root, edges = 0)
    return 0 if root == @root
    return -1 if parent.nil?
    if root < parent
      edges += 1
      depth(root, parent.left, edges)
    elsif root > parent
      edges += 1
      depth(root, parent.right, edges)
    else
      edges
    end
  end

  def balanced?(root = @root)
    return true if root.nil?
    
    lh = height(root.left)
    rh = height(root.right)

    return true if (lh - rh).abs <= 1 && balanced?(root.left) && balanced?(root.right)
    false
  end

  def rebalance
    self.data = inorder
    self.root = build_tree(data)
  end
end

#array = (Array.new(15) { rand(1..100) })
bst = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
#bst = Tree.new(array)
#puts bst.root
#bst.insert(-1)
bst.insert(10)
#bst.insert(11)
bst.pretty_print
#puts bst.find(7)
#bst.delete(67)
#print bst.level_order
#print bst.preorder
#print bst.inorder
#print bst.postorder
#puts bst.height(bst.find(4))
puts bst.depth(bst.find(9))
puts bst.balanced?
bst.rebalance
bst.pretty_print
puts bst.balanced?
