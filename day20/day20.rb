regex = File.read("input.txt")[1..-2]

def pick_option(group)
  return "" if group.match(/(\|\)|\|\||\(\|)/)
  options = group.gsub(/(^\(|\)$)/, "").split("|")
  return options.max_by(&:length)
end

def simplify_path(path)
  while path.match(/\(/)
    # This regex finds the bottom level groups (groups which don't contain any groups)
    # Then pick_option selects the longest necessary one
    path = path.sub(/\([^()]+\)/) {|group| pick_option(group)}
  end
  path
end
# p simplify_path(regex).length

def extract_group(path)
  depth = 0
  path.each_with_index do |c, i|
    if c == "("
      depth += 1
    elsif c == ")"
      depth -= 1
      if depth == 0
        return path[1..i-1]
      end
    end
  end
  return path
end

def split_group(path)
  paths = []
  group_start = 0
  depth = 0
  path.each_with_index do |c, i|
    if c == "("
      depth += 1
    elsif c == ")"
      depth -= 1
    elsif c == "|" && depth == 0
      paths << path[group_start..i-1]
      group_start = i+1
    end
  end
  paths << path[group_start..-1]
  return paths
end

# This code doesn't work and I don't know why. So I went back and rebuilt it in day20_2.rb and that code works

@far_rooms = 0
def count_distance(rooms, max, distance)
  last_move = nil
  rooms.each_with_index do |c, i|
    if c == "("
      group = extract_group(rooms[i..-1])
      paths = split_group(group)
      paths.each do |p|
        count_distance(p, max, distance)
      end
      if group[-1] == "|"
        count_distance(rooms[(i+group.length+2)..-1], max, distance)
      else
        count_distance(rooms[(i+group.length+2)..-1], max, distance)
      end
      break
    elsif (c == "E" && last_move == "W") || (c == "W" && last_move == "E") || (c == "S" && last_move == "N") || (c == "N" && last_move == "S")
        break
    else
      distance += 1
      if(distance >= max)
        @far_rooms += 1
      end
      last_move = c
    end
  end
end
rooms = regex.split("")
count_distance("EE(SN|NS|)E(E|S)".split(""), 2, 0)
# count_distance(rooms, 1000, 0)
p @far_rooms

#         3
#        ---
# X | 1 | 2 | 3 | 4
#        --- ---
#         3   4

# 8658 - not the right answer, too high