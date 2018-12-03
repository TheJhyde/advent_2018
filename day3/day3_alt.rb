# I decide it'd be fun to jam this method down into as few lines as possible
# Actually a different algorithm than the other file. Not faster though.

output = (input = File.read("day3_input.txt").split("\n").map {|n| n[1..-1].split(/@|:|,|x/).map(&:to_i)}).clone
while output.length > 1
  a = output.first
  abort("No Overlaps: #{a[0]}") if (input - [a]).none? do |b|
    output.delete(b) {true} if b[1] < a[1] + a[3] && b[1] + b[3] > a[1] && b[2] < a[2] + a[4] && b[2] + b[4] > a[2]
  end
  input.delete(output.delete(a))
end