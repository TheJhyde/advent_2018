# depth = 510
# target_x = 10
# target_y = 10
depth = 10647
target_x = 7
target_y = 770

def print_array(arr)
  arr.each do |row|
    row.each do |c|
      # erosion = (c + depth) % 20183
      print "M" if c == "M"
      print "." if c % 3 == 0 #rocky
      print "=" if c % 3 == 1 #wet
      print "|" if c % 3 == 2 #narrow
      # print c
      # print " "
    end
    print "\n"
  end
end

def geo_index(x, y, cave)
  return cave[x][y] unless cave[x][y].nil?

  return y * 48271 if x == 0
  return x * 16807 if y == 0

  return cave[x-1][y] * cave[x][y-1]
end

cave = [[depth % 20183]]


(1..target_y).each do |i|
  cave[i] = []
  i.times do |j|
    cave[i][j] = (geo_index(i, j, cave) + depth) % 20183
    cave[j][i] = (geo_index(j, i, cave) + depth) % 20183
    # cave[i][j] = 0
    # cave[j][i] = 0
  end
  cave[i][i] = (geo_index(i, i, cave) + depth) % 20183
  # cave[i][i] = 0
end

cave[target_x][target_y] = depth % 20183
# print_array(cave)

risk = 0
(0..target_x).each do |x|
  (0..target_y).each do |y|
    risk += cave[x][y] % 3
  end
end
# risk = cave.reduce(0) do |acc, row|
#   acc + row.reduce(0) do |acc2, square|
#     acc2 + square % 3
#   end
# end

p risk
