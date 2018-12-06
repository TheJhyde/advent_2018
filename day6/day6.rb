require 'set'

input = File.read("input.txt").scan(/\d+/).map {|c| c.to_i}.each_slice(2).to_a
x_max = input.max_by {|c| c[0]}[0]
y_max = input.max_by {|c| c[1]}[1]

edge = Set[]
close_distances = 0
counts = Array.new(input.length, 0)

def man_dist(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

x_max.times do |i|
  y_max.times do |j|
    
    total_dist = 0
    min_distance = x_max
    index = -1
    collision = false

    input.each_with_index do |c, k| 
      dist = man_dist(c[0], c[1], i, j)
      total_dist += dist
      if dist < min_distance
        index = k
        min_distance = dist
        collision = false
      elsif dist == min_distance
        collision = true
      end
    end

    unless collision
      if i == 0 || i == x_max - 1 || j == 0 || j == y_max - 1
        edge << index
      else
        counts[index] += 1
      end
    end

    if total_dist < 10000
      close_distances += 1
    end
  end
end

edge.each do |i|
  counts[i] = 0
end

p counts.max
p close_distances