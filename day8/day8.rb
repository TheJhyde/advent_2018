# raw = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
raw = File.read("input.txt")
input = raw.split(" ").map {|x| x.to_i}

class Node
  attr_accessor :nodes, :meta, :remaining_input

  def initialize(input)
    # I'd love to put process_node into this initializer
    # but process_node needs to return the remaining input
    # and I don't think initial can return anything other than the object
    self.nodes = []

    node_count = input[0]
    meta_count = input[1]
    input = input[2..-1]

    node_count.times do
      node = Node.new(input)
      input = node.remaining_input
      self.nodes << node
    end

    self.meta = input.slice(0, meta_count)
    self.remaining_input = input[meta_count..-1]
  end

  def all_meta
    meta.reduce(&:+) + nodes.reduce(0) {|acc, x| acc + x.all_meta}
  end

  def sum
    if nodes.length == 0
      meta.reduce(&:+)
    else
      meta.reduce(0) do |acc, x|
        i = x - 1
        if i == -1 || nodes[i].nil?
          acc
        else
          acc + nodes[i].sum
        end
      end
    end
  end
end

root = Node.new(input)
p root.all_meta
p root.sum
