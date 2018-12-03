def compare_strings(a, b)
  differences = 0
  a.length.times do |i|
    if a[i] != b[i]
      differences += 1
      if differences >= 2
        return false
      end
    end
  end
  return differences == 1
end

input = File.read("day2_input.txt").split("\n")

twos = 0;
threes = 0;

input.each_with_index do |id1, index|
  found_two = false
  found_three = false

  id1.split("").uniq.each do |c|
    count = id1.scan(c).count
    if count == 2 && !found_two
      twos += 1
      found_two = true
    end
    if count == 3 && !found_three
      threes += 1
      found_three = true
    end
    if found_two && found_three
      break
    end
  end

  input.slice(index+1, input.length).each do |id2|
    if compare_strings(id1, id2)
      p "Same but one: #{id1} and #{id2}"
      break
    end
  end
end

p "Hash: #{twos * threes}"