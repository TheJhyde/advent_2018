# This is, honestly, the correct way to do it

class Link
  attr_accessor :next, :previous, :value

  def initialize(value)
    self.value = value
    self.next = self
    self.previous = self
  end

  def forward(value)
    if value <= 0
      self
    else
      self.next.forward(value - 1)
    end
  end

  def backward(value)
    if value <= 0
      self
    else
      self.previous.backward(value - 1)
    end
  end

  def insert(value)
    new_link = Link.new(value)

    new_link.next = self.next
    new_link.previous = self

    self.next.previous = new_link
    self.next = new_link
    new_link
  end

  def remove
    self.previous.next = self.next
    self.next.previous = self.previous

    old_next = self.next
    self.next = nil
    self.previous = nil

    old_next
  end
end

class Circle
  attr_accessor :head

  def initalize(first)
    self.head = Link.new(first)
  end

  def append()

  end
end

def winning_score(players, last)
  current_marble = Link.new(0)
  zero = current_marble
  scores = Array.new(players, 0)
  current_player = 0

  (1..last).each do |i|
    current_player = (current_player + 1) % players

    if i % 23 == 0
      scores[current_player] += i
      current_marble = current_marble.backward(7)
      scores[current_player] += current_marble.value
      current_marble = current_marble.remove
    else
      current_marble = current_marble.forward(1).insert(i)
    end
  end

  scores.max
end

p winning_score(478, 71240)
p winning_score(478, 7_124_000)