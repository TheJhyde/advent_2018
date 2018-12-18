input = File.read("test_input.txt").split("\n").map {|l| l.split("")}
combatants = []

input.length.times do |x|
  input[x].length.times do |y|
    if input[x][y] == "G"
      combatants << ["G", x, y]
      input[x][y] = "."
    elsif input[x][y] == "E"
      combatants << ["E", x, y]
      input[x][y] = "."
    end
  end
end

combatants.sort_by! {|cart| [cart.y, cart.x]}
combatants.each do |fighter|
  # move
  enemies = combatants.select {|f| f[0] != fighter[0]}
  in_range = enemies.map do |f|
    ((f[1]-1)..(f[1]+1)).each do |x|
      ((f[2]-1)..(f[2]+1)).each do |y|
        
      end
    end
  end
  # ??????????????

  # attack
end