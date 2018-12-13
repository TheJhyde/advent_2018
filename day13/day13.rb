raw = File.read("input.txt" )

class Cart
  attr_accessor :direction, :turns, :x, :y, :active

  def initialize(direction, x, y)
    self.turns = 1
    @directions = ["^", "<", "v", ">"]

    self.direction = @directions.index(direction)
    self.x = x
    self.y = y
    self.active = true
  end

  def move
    direction_values = [[0, -1], [-1, 0], [0, 1], [1, 0]]
    self.x += direction_values[self.direction][0]
    self.y += direction_values[self.direction][1]
  end

  def intersection
    if self.turns == 1 || self.turns == 3
      self.direction = (self.direction + self.turns) % 4
    end
    self.turns = (self.turns % 3) + 1
  end

  def to_s
    @directions[self.direction]
  end
end

def print_grid(grid, carts)
  grid.each_with_index do |column, i|
    column.each_with_index do |n, j|
      cart = carts.find {|c| c.x == j && c.y == i}
      print cart.nil? ? n : cart
    end
    print "\n"
  end
end

cart_regex = /[\^\<\>v]/
input = raw.split("\n").map {|r| r.chars}

carts = []
input.each_with_index do |row, i|
  row.each_with_index do |n, j|
    if n.match(cart_regex)
      carts << Cart.new(n, j, i)
      input[i][j] = n.match(/[\^v]/) ? "|" : "-"
    end
  end
end

rounds = 0
loop do
  carts.sort_by! {|cart| [cart.y, cart.x]}
  carts.each do |cart|
    direction_values = [[0, -1], [-1, 0], [0, 1], [1, 0]]
    dx = cart.x + direction_values[cart.direction][0]
    dy = cart.y + direction_values[cart.direction][1]
    collider = carts.find {|c| c.x == dx && c.y == dy}
    if !collider.nil?
      p "Cart eliminated at #{dx}, #{dy}"
      collider.active = false
      cart.active = false
      cart.x = dx
      cart.y = dy
      next
    end
    cart.x = dx
    cart.y = dy

    spot = input[cart.y][cart.x]
    if spot == "\\"
      case cart.direction
      when 0 then cart.direction = 1
      when 1 then cart.direction = 0
      when 2 then cart.direction = 3
      when 3 then cart.direction = 2
      end
    elsif spot == "/"
      cart.direction = 3 - cart.direction
    elsif spot == "+"
      cart.intersection
    end
  end
  carts = carts.select {|c| c.active}
  break if carts.length == 1
  rounds += 1
end

p "End: #{carts[0].x},#{carts[0].y}"