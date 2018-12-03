# [0, 1, 2, 3, 4]
# 0 - id
# 1 - x coord
# 2 - y coord
# 3 - width
# 4 - height

# raw = "#1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2"
raw = File.read("day3_input.txt")
input = raw.split("\n").map {|n| n[1..-1].split(/@|:|,|x/).map(&:to_i)}

cloth = []

input.each do |coords|
  coords[3].times do |i|
    coords[4].times do |j|
      cloth[i + coords[1]] ||= []
      cloth[i + coords[1]][j + coords[2]] ||= 0
      cloth[i + coords[1]][j + coords[2]] += 1
    end
  end
end

overlaps = cloth
.reduce(0) do |acc, col| 
  if col.nil?
    acc
  else
    acc + col.reduce(0) do |acc, n| 
      !n.nil? && n >= 2 ? acc + 1 : acc
    end
  end
end

p "overlaps: #{overlaps}"

alone = input.reduce([]) do |acc, coords|
  overlapping = false
  coords[3].times do |i|
    coords[4].times do |j|
      x = i + coords[1]
      y = j + coords[2]
      if cloth[x][y] > 0
        cloth[x][y] = -coords[0]
      else
        acc.delete(cloth[x][y])
        overlapping = true
      end
    end
  end
  unless overlapping
    acc << -coords[0]
  end
  acc
end

p "Valid entries #{-alone[0]}"
p "Found more than one valid entry! That shouldn't happen" if alone.length != 1