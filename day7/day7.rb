require_relative 'elf.rb'
require_relative 'task.rb'

# raw = %q(Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin.)
raw = File.read("input.txt")

requirements = raw.scan(/Step\s(.).+step\s(.)\s/)

steps = {}
requirements.each do |rule|
  steps[rule[0]] ||= Task.new(rule[0])
  steps[rule[1]] ||= Task.new(rule[1])
  steps[rule[1]].requirements << steps[rule[0]]
end

sequence = []
while sequence.length < steps.length
  valid_steps = steps.select {|k,v| !v.finished? && v.can_run?}
  next_step = valid_steps.min[1]
  sequence << next_step.name
  next_step.status = :finished
end

p sequence.join

# Have to reset all the steps for part 2
steps.each do |k, v|
  v.status = :start
end

seconds = 0
elves = Array.new(5){Elf.new}
loop do
  elves.each do |e|
    if e.tasked?
      e.task.seconds -= 1
      if e.task.finished?
        e.reset
      end
    end
  end

  valid_steps = steps.select {|k, v| v.can_run?}.values.sort
  elves.find_all {|e| !e.tasked?}.each_with_index do |elf, i|
    if i >= valid_steps.length
      break
    else
      elf.set(valid_steps[i])
    end
  end

  break if steps.none? {|k, v| !v.finished?}
  seconds += 1
end

p seconds