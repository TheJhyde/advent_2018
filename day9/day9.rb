def winning_score(players, last)
  circle = [0, 1]
  current_index = 1;
  players = players;
  scores = Array.new(players, 0)
  current_player = 0

  (2..last).each do |i|
    current_player = (current_player + 1) % players

    if i % 23 == 0
      scores[current_player] += i
      current_index = (current_index - 7) % circle.length
      scores[current_player] += circle.slice!(current_index)
    else
      insert_at = (current_index+1) % circle.length + 1
      circle.insert(insert_at,i)
      current_index = insert_at
    end
    if i % 100_000 == 0
      p i
    end
  end

  scores.max
end

p winning_score(478, 71240)
# p winning_score(478, 7_124_000)