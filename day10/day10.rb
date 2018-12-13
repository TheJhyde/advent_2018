raw = File.read("input.txt" )
# raw = %q(position=< 9,  1> velocity=< 0,  2>
# # position=< 7,  0> velocity=<-1,  0>
# # position=< 3, -2> velocity=<-1,  1>
# # position=< 6, 10> velocity=<-2, -1>
# # position=< 2, -4> velocity=< 2,  2>
# # position=<-6, 10> velocity=< 2, -2>
# # position=< 1,  8> velocity=< 1, -1>
# # position=< 1,  7> velocity=< 1,  0>
# # position=<-3, 11> velocity=< 1, -2>
# # position=< 7,  6> velocity=<-1, -1>
# # position=<-2,  3> velocity=< 1,  0>
# # position=<-4,  3> velocity=< 2,  0>
# # position=<10, -3> velocity=<-1,  1>
# # position=< 5, 11> velocity=< 1, -2>
# # position=< 4,  7> velocity=< 0, -1>
# # position=< 8, -2> velocity=< 0,  1>
# # position=<15,  0> velocity=<-2,  0>
# # position=< 1,  6> velocity=< 1,  0>
# # position=< 8,  9> velocity=< 0, -1>
# # position=< 3,  3> velocity=<-1,  1>
# # position=< 0,  5> velocity=< 0, -1>
# # position=<-2,  2> velocity=< 2,  0>
# # position=< 5, -2> velocity=< 1,  2>
# # position=< 1,  4> velocity=< 2,  1>
# # position=<-2,  7> velocity=< 2, -2>
# # position=< 3,  6> velocity=<-1, -1>
# # position=< 5,  0> velocity=< 1,  0>
# # position=<-6,  0> velocity=< 2,  0>
# # position=< 5,  9> velocity=< 1, -2>
# # position=<14,  7> velocity=<-2,  0>
# # position=<-3,  6> velocity=< 2, -1>)

num_reg = /[\-\s]\d+/
input = raw
  .scan(/position=<([\-\s]?\d+), ([\-\s]?\d+)> velocity=<([\-\s]?\d+), ([\-\s]?\d+)>/)
  .map {|x| x.map {|y| y.to_i}}

def print_coordinates(coords)
  x_min = coords.min_by{|c| c[0]}[0]
  x_max = coords.max_by{|c| c[0]}[0]
  y_min = coords.min_by{|c| c[1]}[1]
  y_max = coords.max_by{|c| c[1]}[1]

  (y_min..y_max).each do |y|
    (x_min..x_max).each do |x|
      if coords.any? {|c| c[0] == x && c[1] == y}
        print "#"
      else
        print " "
      end
    end
    print "|\n"
  end
end

def step(coords)
  coords.map do |c|
    [
      c[0] + c[2],
      c[1] + c[3],
      c[2],
      c[3]
    ]
  end
end

def check(coords)
  aligned = coords.all? do |c|
    coords.any? do |c2| 
      c2[0] <= c[0] + 1 && c2[0] >= c[0] - 1 &&
      c2[1] <= c[1] + 1 && c2[1] >= c[1] - 1 &&
      (c[0] != c2[0] || c[1] != c2[1])
    end
  end
end

seconds = 0
loop do
  seconds += 1
  input = step(input)
  if check(input)
    p "-" * 100
    print_coordinates(input)
    i = gets.chomp
    if i == "s"
      break
    end
  end
end

p seconds
