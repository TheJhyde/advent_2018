# There 1,040 elements on the list
# Sum is 569
# Average is 0.54
# Largest number is 76,787
# Smallest number -77371

# So for each entry in the input, we can make a column
# And the output for that column is = (cycle number) * (total sum) + (column's sum in the first cycle)
# This is a linear equation - ax + b. And every column has the same a - the sum of the entire sequence
# I'm not looking for intersections, which is good because there are none. All these lines are parallel
# I'm looking for whole number values where these two entries produce the same value

# Is it possible to have a combination of values which will never produce the same values?
# Yes: 
# 2x + 1: 1 3 5 7 9 11
# 2x + 0: 0 2 4 6 8 10
# Those two sequences will never share a number

# What are the attributes of sequences which will produce the same values?
# 4x + 5:  *5* 9 13  17
# 4x - 3:  -3  1 *5*  9
# I think the important attribute is that the difference between these two values is divisible by the sum, (5 - -3 = 8, 8 % 4 = 0).

# Given two sequences that I think will share a value, how to determine what that value is?
# In the examples that I've tried, the first value always showed up in the first cycle, the larger value
# So let's assume that's true, so that makes it:
# a * x + b1 = b2
# x = (b2 - b1)/a
# x = round we're on

require 'benchmark'

time = Benchmark.measure do
  input = File.open("day1_input.txt").map {|n| n.to_i}

  sums = input.reduce([]) {|s, n| s = s + [n + (s.last || 0)]}
  sum = sums.last

  p "Sum: #{sum}"

  repeat = 0
  round = 9999999
  place = sums.length + 1
  sums.each_with_index do |i, index|
    sums.slice(index+1, sums.length).each do |j|
      diff = (i - j).abs
      if diff % sum == 0
        match_round = diff/sum
        if match_round < round || (match_round == round && index < place)
          repeat = i > j ? i : j
          round = match_round
          place = index
        end
      end
    end
  end
  # Cases this algorithm won't catch:
    # Repeating value is 0 - it'll find the next value
    # If the sum is negative

  p "Repeating Frequency: #{repeat}"
end

p ""
p " cpu        system     total    (real)"
puts time
