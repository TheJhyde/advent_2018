class Register
  attr_accessor :regs, :ip

  def initialize(ip, registers)
    self.regs = registers
    self.ip = ip
  end

  def pointer
    self.regs[self.ip]
  end

  def tick
    self.regs[self.ip] += 1
  end

  def register_say(c)
    c == self.ip ? " This effects the pointer" : ""
  end

  [["add", :+, "add"], ["mul", :*, "multiply"], ["ban", :&, "binary and"], ["bor", :|, "binary or"]].each do |instr|
    define_method "#{instr[0]}r" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], self.regs[b])
      self.regs
    end

    define_method "#{instr[0]}r_say" do |a, b, c|
      "#{instr[2]} register #{a} (#{self.regs[a]}) and register #{b} #{self.regs[b]}, save result in register #{c}.#{register_say(c)}"
    end

    define_method "#{instr[0]}r_code" do |a, b, c|
      "regs[#{c}] = regs[#{a}] #{instr[1].to_s} regs[#{b}]"
    end

    define_method "#{instr[0]}i" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], b)
      self.regs
    end

    define_method "#{instr[0]}i_say" do |a, b, c|
      "#{instr[2]} register #{a} (#{self.regs[a]}) and #{b}, save result in register #{c}.#{register_say(c)}"
    end

    define_method "#{instr[0]}i_code" do |a, b, c|
      "regs[#{c}] = regs[#{a}] #{instr[1].to_s} #{b}"
    end
  end

  def setr(a, b, c)
    self.regs[c] = self.regs[a]
    self.regs
  end

  def seti(a, b, c)
    self.regs[c] = a
    self.regs
  end

  def setr_say(a, b, c)
    "Set register #{c} to the value of register #{a} (#{self.regs[a]}).#{register_say(c)}"
  end

  def seti_say(a, b, c)
    "Set register #{c} to #{a}.#{register_say(c)}"
  end

  def setr_code(a, b, c) "regs[#{c}] = regs[#{a}]" end
  def seti_code(a, b, c) "regs[#{c}] = #{a}" end


  {gt: :>, eq: :==}.each do |k, v|
    define_method "#{k}ir" do |a, b, c|
      self.regs[c] = a.send(v, self.regs[b]) ? 1 : 0
      self.regs
    end

    define_method "#{k}ir_say" do |a, b, c|
      "Is #{a} #{v.to_s} register #{b} (#{self.regs[b]})? Save result in register #{c}.#{register_say(c)}"
    end
    define_method("#{k}ir_code") {|a, b, c| "regs[#{c}] = #{a} #{v.to_s} regs[#{b}] ? 1 : 0"}

    define_method "#{k}ri" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, b) ? 1 : 0
      self.regs
    end

    define_method "#{k}ri_say" do |a, b, c|
      "Is register #{a} ((#{self.regs[a]})) #{v.to_s} #{b}? Save result in register #{c}.#{register_say(c)}"
    end
    define_method("#{k}ri_code") {|a, b, c| "regs[#{c}] = regs[#{a}] #{v.to_s} #{b} ? 1 : 0"}

    define_method "#{k}rr" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, self.regs[b]) ? 1 : 0
      self.regs
    end

    define_method "#{k}rr_say" do |a, b, c|
      "Is register #{a} ((#{self.regs[a]})) #{v.to_s} register #{b} (#{self.regs[b]})? Save result in register #{c}.#{register_say(c)}"
    end
    define_method("#{k}rr_code") {|a, b, c| "regs[#{c}] = regs[#{a}] #{v.to_s} regs[#{b}] ? 1 : 0"}
  end
end

input = File.read("input.txt").split("\n")
ip = input.shift.scan(/\d/)[0].to_i
# start = [0, 0, 10551380, 7, 1, 10551381]
# start = [2, 120, 60, 3, 2, 10551381]
start = [1, 0, 0, 0, 0, 0, 0]
r = Register.new(ip, start)
instructions = input.map do |line|
  arr = line.split(" ")
  [arr[0]] + arr[1..3].map(&:to_i)
end


# instructions.each_with_index do |ins, i|
#   p "#{i}: " + r.send("#{ins[0]}_say", *ins[1..3])
# end

# loop = 3, 4, 5, 6, 8, 9, 10, 11
50.times do 
  instruct = instructions[r.pointer]
  # print "##{r.pointer} - "
  if instruct[3] == ip
    print "# switch\n"
  end
  print r.send("#{instruct[0]}_code", instruct[1], instruct[2], instruct[3])
  print "\n"
  # p r.regs
  r.send(*instruct)
  # p r.regs
  # if r.pointer == 3
  #   p r.regs
  # end
  break unless r.pointer + 1 < instructions.length
  # p "-----"

  print "regs[#{ip}] += 1\n"
  r.tick
end
p "----end----"
p r.regs
p r.pointer

