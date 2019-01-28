require 'set'

class Room
  attr_accessor :N, :W, :S, :E, :x, :y, :distance

  def move(direction, all)
    room = self.send(direction.to_sym)
    return room unless room.nil?

    new_x = self.x
    new_y = self.y

    case direction
    when "W"
      new_x -= 1
    when "E"
      new_x += 1
    when "N"
      new_y += 1
    when "S"
      new_y -= 1
    end

    room = all.find {|r| r.x == new_x && r.y == new_y}
    return room unless room.nil?

    room = Room.new()
    room.x = new_x
    room.y = new_y
    room.distance = self.distance + 1
    case direction
    when "W"
      self.W = room
      room.E = self
    when "E"
      self.E = room
      room.W = self
    when "N"
      self.N = room
      room.S = self
    when "S"
      self.S = room
      room.N = self
    end

    all << room
    return room
  end
end

def extract_group(path)
  paths = []
  group_start = 0
  depth = 0
  path.shift
  path.each_with_index do |c, i|
    if c == "("
      depth += 1
    elsif c == ")"
      depth -= 1
      if depth == -1
        paths << path[group_start..i-1]
        return paths
      end
    elsif c == "|" && depth == 0
      paths << path[group_start..i-1]
      group_start = i+1
    end
  end
  paths << path[group_start..-1]
  return paths
end

def build_map(path, all, place)
  path.each_with_index do |c, i|
    if c == "("
      paths = extract_group(path[i..-1])
      paths.each do |p|
        build_map(p, all, place)
      end
      if(paths[-1] == [])
        build_map(path[(i+paths.flatten.length+3)..-1], all, place)
      end
      break
    else
      place = place.move(c, all)
    end
  end
end

start = Room.new
start.x = 0
start.y = 0
start.distance = 0
all_rooms = Set.new([start])

regex = File.read("input.txt").split("")[1..-2]
build_map(regex, all_rooms, start)
# p all_rooms.max_by(&:distance).distance
p all_rooms.count {|r| r.distance >= 1000 }
