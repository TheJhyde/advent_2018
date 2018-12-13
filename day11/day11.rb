grid_id = 7165
# grid_id = 18

grid = []

(0..300).each do |x|
  a = x*x + 20*x+100
  b = (x + 10) * grid_id
  grid[x] = []
  (0..300).each do |y|
    power_level = y * a + b
    digit = power_level.to_s[-3]
    grid[x][y] = (digit.nil? ? 0 : digit.to_i) - 5
  end
end

def max_squares(x, y, grid)
  limiter = x > y ? x : y
  max = 0
  max_size = 0
  sum = grid[x][y]
  (2..(grid.length - limiter)).each do |length|
    (0...(length-1)).each do |i|
      sum += grid[x+length-1][y+i]
      sum += grid[x+i][y+length-1]
    end
    sum += grid[x+length-1][y+length-1]
    if sum > max
      max = sum
      max_size = length
    end
  end
  [max, max_size]
end

max = 0
max_x = 0
max_y = 0
size = 0
(0..300).each do |x|
  if x % 50 == 0
    p x
  end
  (0..300).each do |y|
    # sum = 0
    # (0..2).each do |i|
    #   (0..2).each do |j|
    #     sum += grid[x+i][y+j]
    #   end
    # end
    # if sum > max
    #   max = sum
    #   max_x = x
    #   max_y = y
    # end
    squares = max_squares(x, y, grid)
    if squares[0] > max
      max_x = x
      max_y = y
      size = squares[1]
      max = squares[0]
    end
  end
end

p "#{max_x},#{max_y},#{size}"