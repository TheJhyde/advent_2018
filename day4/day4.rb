require 'date'

raw = File.read("day4_input.txt")
input = raw
  .split("\n")
  .map {|n| {time: DateTime.parse(n[1, 16]), event: n[19..-1]}}
  .sort {|x,y| x[:time] <=> y[:time]}

guards = {}
current_guard = ""
i = 0
while i < input.length
  log = input[i]
  if log[:event].start_with? "Guard"
    current_guard = log[:event].split(" ")[1]
    guards[current_guard] ||= Array.new(60, 0)
    i += 1
  elsif log[:event].start_with? "falls"
    # three dots here for an exclusive range
    (log[:time].minute...input[i+1][:time].minute).each do |m|
      guards[current_guard][m] += 1
    end
    i += 2
  else
    i += 1
  end
end

sleepy = guards.max_by {|k, v| v.reduce(&:+)}
guard = sleepy[0][1..-1].to_i
minute = sleepy[1].each_with_index.max[1]
p "Guard: #{guard}, Minute: #{minute}, combo: #{guard * minute}"

sleepy2 = guards.max_by {|k, v| v.max}
guard = sleepy2[0][1..-1].to_i
minute = sleepy2[1].each_with_index.max[1]
p "Guard: #{guard}, Minute: #{minute}, combo: #{guard * minute}"