class Recipe
  attr_accessor :score, :next_recipe, :start

  def initialize(input, start = self)
    self.score = input
    self.start = start
    self.next_recipe = nil
  end

  def forward(value)
    if value <= 0
      self
    else
      if self.next_recipe.nil?
        # If we're at the end, loop back around to the start
        self.start.forward(value - 1)
      else
        self.next_recipe.forward(value - 1)
      end
    end
  end
end

head = Recipe.new(3)
tail = Recipe.new(7, head)
head.next_recipe = tail
recipe_count = 2

elf1 = head
elf2 = tail

# input = "323081"
input = "323081".split("").map(&:to_i)
compare_index = 0

loop do
  (elf1.score + elf2.score).digits.reverse.each do |s|
    r = Recipe.new(s.to_i, head)
    tail.next_recipe = r
    tail = r
    recipe_count += 1
    compare_index = (s == input[compare_index]) ? compare_index + 1 : 0
    break if compare_index >= input.length
  end

  if compare_index >= input.length
    p recipe_count - input.length
    break
  end

  elf1 = elf1.forward(elf1.score + 1)
  elf2 = elf2.forward(elf2.score + 1)
end