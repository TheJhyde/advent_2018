input = File.read("test_input.txt" ).scan(/([xy])\=(\d+), [xy]\=(\d+)\.{2}(\d+)/)

clay = []
input.each do |line|
  (line[2]..line[3]).to_a.map do |i|
    c = line[0] == "x" ? [line[1].to_i, i.to_i] : [i.to_i, line[1].to_i]
    clay << c
  end
end

p clay

lowest_point = clay.max_by {|c| c[1]}[1]
p lowest_point

def print_ground

end

def check_filled(pos, clay, water)
  clay.any? {|c| c == pos} && water.any? {|c| c == pos}
end

water = [500, 0]
path = []
while water[1] >= lowest_point
  if !check_filled([water[0], water[1]+1], clay, path)
    path << water.dup
    water[1] += 1
    next
  end

  spread = 1
  hit_right = false
  hit_left = false
  loop do
    right = [water[0]+spread, water[1]]
    if !hit_right && !check_filled(right, clay, path)
      path << right
      if !check_filled([water[0]+spread, water[1]+1], clay, path)
        water = right
        next
      end
    else
      hit_right = true
    end

    left = [water[0]-spread, water[1]]
    if !hit_left && !check_filled(left, clay, path)
      path << left
      if !check_filled([water[0]-spread, water[1]+1], clay, path)
        water = left
        next
      end
    else
      hit_left = true
    end

    if hit_left && hit_right
      water[1] -= 1
    end
  end
end

p path.length
p path