# i = 1
# j = 0
# if !(i == 0 && j == 0)
#   p "yeah"
# end

input = File.read("input.txt").split("\n").map {|r| r.split("")}

field = input.freeze

def print_field(field)
  field.each do |row|
    row.each do |entry|
      print entry
    end
    print "\n"
  end
end

def next_element(x, y, field)
  open = 0
  trees = 0
  yards = 0
  (-1..1).each do |i|
    (-1..1).each do |j|
      if !(i == 0 && j == 0) && x+i >= 0 && x+i < field[y].length && y+j >= 0 && y+j < field.length
        neighbor = field[y+j][x+i]
        open += neighbor == "." ? 1 : 0
        trees += neighbor == "|" ? 1 : 0
        yards += neighbor == "#" ? 1 : 0
      end
    end
  end
  if field[y][x] == "."
    trees >= 3 ? "|" : "."
  elsif field[y][x] == "|"
    yards >= 3 ? "#" : "|"
  else
    (yards >= 1 && trees >= 1) ? "#" : "."
  end
end

# Just set the offset to 10 instead of 445 to get part 1
# offset = 445
# offset.times do
#   new_field = Array.new(field.length) {Array.new(field[0].length)}
#   field.length.times do |y|
#     field[y].length.times do |x|
#       new_field[y][x] = next_element(x, y, field)
#     end
#   end
#   field = new_field
# end

# sequence = []
# 28.times do |i|
#   woods = 0
#   yards = 0
#   new_field = Array.new(field.length) {Array.new(field[0].length)}
#   field.length.times do |y|
#     field[y].length.times do |x|
#       new_field[y][x] = next_element(x, y, field)
#       woods += 1 if new_field[y][x] == "|"
#       yards += 1 if new_field[y][x] == "#"
#     end
#   end
#   sequence << [woods, yards]
#   field = new_field
# end
# p sequence

# The above code generates this sequence, which is how the automata repeat after a certain point
sequence = [[594, 338], [597, 334], [598, 338], [602, 330], [605, 334], [610, 329], [613, 337], [619, 334], [621, 344], [625, 343], [628, 348], [632, 344], [634, 351], [638, 349], [641, 354], [641, 354], [638, 360], [637, 355], [631, 360], [622, 362], [611, 367], [605, 356], [600, 350], [598, 343], [594, 344], [595, 330], [594, 335], [594, 332]]

# Test the sequence, find the proper offset
# input = File.read("input.txt").split("\n").map {|r| r.split("")}
# field = input
# 600.times do |i|
#   new_field = Array.new(field.length) {Array.new(field[0].length)}
#   woods = 0
#   yards = 0
#   field.length.times do |y|
#     field[y].length.times do |x|
#       new_field[y][x] = next_element(x, y, field)
#       woods += 1 if new_field[y][x] == "|"
#       yards += 1 if new_field[y][x] == "#"
#     end
#   end
#   field = new_field
#   if i > 500
#     # Down here, we're on i + 1 rounds
#     if [woods, yards] != sequence[(i+3) % 28]
#       p "problem, checked #{(i+3)%28}, should be #{sequence.index([woods, yards])} at #{i+1}"
#     end
#   end
# end
# p "done!"

# And then get the correct answer
big_one = sequence[(1000000000 + 2) % 28]
p big_one
p big_one[0] * big_one[1]

# It's not 224237