raw = File.read("input.txt")

def react_polymer(input)
  polymer = input.dup
  i = 0
  while i < polymer.length - 1
    if polymer[i].upcase == polymer[i+1].upcase && polymer[i] != polymer[i+1]
      cleared = 0
      polymer.slice!(i, 2)
      i -= 2
    end
    i += 1
  end

  polymer.length
end

p react_polymer(raw)

worst = raw.downcase.split("").uniq.min_by() do |n|
  react_polymer(raw.gsub(/[#{n}#{n.upcase}]/, ""))
end

p react_polymer(raw.gsub(/[#{worst}#{worst.upcase}]/, ""))