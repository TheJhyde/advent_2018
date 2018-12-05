raw = File.read("input.txt")

def react_polymer(polymer)
  raw = polymer.dup
  cleared = false
  i = 0
  while i < raw.length - 1
    if raw[i] != raw[i+1] && raw[i].upcase == raw[i+1].upcase
      cleared = 0
      raw.slice!(i, 2)
      i -= 2
      cleared = false
    end
    i += 1
  end

  raw.length
end

p react_polymer(raw)

worst = raw.downcase.split("").uniq.min_by() do |n|
  react_polymer(raw.gsub(n, "").gsub(n.upcase, ""))
end

p react_polymer(raw.gsub(worst, "").gsub(worst.upcase, ""))