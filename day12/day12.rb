padding = 20
initial_state = ("#{"."*padding}#...####.##..####..#.##....##...###.##.#..######..#..#..###..##.#.###.#####.##.#.#.#.##....#..#..#..#{"."*padding}")
rules = %q(...## => .
...#. => #
....# => .
###.# => #
..... => .
..#.. => .
#.#.# => .
#..#. => .
#...# => .
##... => .
.#.#. => #
.#..# => .
.###. => .
#..## => #
..#.# => #
.#### => #
##..# => #
##.#. => #
.#... => #
#.#.. => .
##### => .
###.. => #
.##.# => .
#.##. => .
..### => .
.#.## => #
..##. => #
#.### => .
.##.. => #
##.## => .
#.... => .
####. => #).scan(/([#\.]{5}) => ([#\.])/).to_h

# state = "#{"."*padding}#..#.#..##......###...####{"."*padding}"
# # p state

# rules = %q(...## => #
# ..#.. => #
# .#... => #
# .#.#. => #
# .#.## => #
# .##.. => #
# .#### => #
# #.#.# => #
# #.### => #
# ##.#. => #
# ##.## => #
# ###.. => #
# ###.# => #
# ####. => #).scan(/([#\.]{5}) => ([#\.])/).to_h

def sum_garden(garden, padding)
  garden
    .split("")
    .each_with_index
    .find_all {|x| x[0] == "#"}
    .reduce(0) {|acc, x| acc + x[1] - padding}
end

# generations: 50000000000
state = initial_state
sums = []
114.times do |i|
  new_state = state[0,2]
  (2..state.length).each do |n|
    chunk = state[n-2,5]
    if chunk.length == 5
      new_state += rules[chunk].nil? ? "." : rules[chunk]
    else
      new_state += "."
    end
    
  end
  state = new_state  
  # sums << sum_garden(state, padding)
end

sum = sum_garden(state, padding)
p sum
p sum + (50000000000 - 114) * 80





# Incorrect: 3763