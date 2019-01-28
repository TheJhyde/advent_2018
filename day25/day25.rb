input = File.read("input.txt").split("\n").map {|l| l.split(",").map(&:to_i)}

def manhattan_distance(a, b)
  distance = 0
  a.each_with_index do |n, i|
    distance += (n - b[i]).abs
  end
  distance
end

constellations = []
while input.length > 0
  new_cons = [input[0]]
  input.slice!(0)
  index = 0
  while index < new_cons.length
    input.reject! do |con|
      if manhattan_distance(con, new_cons[index]) <= 3
        new_cons << con
        # p "added #{con}, compared to "
        true
      else
        false
      end
    end
    index += 1
  end
  p "--"
  constellations << new_cons
end

# p constellations
p constellations.length