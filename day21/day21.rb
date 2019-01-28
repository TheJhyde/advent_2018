require 'set'

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

  [["add", :+, "add"], ["mul", :*, "multiply"], ["ban", :&, "binary AND"], ["bor", :|, "binary OR"]].each do |instr|
    define_method "#{instr[0]}r" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], self.regs[b])
      self.regs
    end

    define_method "#{instr[0]}r_say" do |a, b, c|
      "#{instr[2]} register #{a} and register #{b}, save result in register #{c}.#{register_say(c)}"
    end

    define_method "#{instr[0]}i" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], b)
      self.regs
    end

    define_method "#{instr[0]}i_say" do |a, b, c|
      "#{instr[2]} register #{a} and #{b}, save result in register #{c}.#{register_say(c)}"
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
    "Set register #{c} to the value of register #{a}.#{register_say(c)}"
  end

  def seti_say(a, b, c)
    "Set register #{c} to #{a}.#{register_say(c)}"
  end

  {gt: :>, eq: :==}.each do |k, v|
    define_method "#{k}ir" do |a, b, c|
      self.regs[c] = a.send(v, self.regs[b]) ? 1 : 0
      self.regs
    end

    define_method "#{k}ir_say" do |a, b, c|
      "Is #{a} #{v.to_s} register #{b}? Save result in register #{c}.#{register_say(c)}"
    end

    define_method "#{k}ri" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, b) ? 1 : 0
      self.regs
    end

    define_method "#{k}ri_say" do |a, b, c|
      "Is register #{a} #{v.to_s} #{b}? Save result in register #{c}.#{register_say(c)}"
    end

    define_method "#{k}rr" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, self.regs[b]) ? 1 : 0
      self.regs
    end

    define_method "#{k}rr_say" do |a, b, c|
      "Is register #{a} #{v.to_s} register #{b}? Save result in register #{c}.#{register_say(c)}"
    end
  end
end

input = File.read("input.txt").split("\n")
ip = input.shift.scan(/\d/)[0].to_i
start = Array.new(["n", 0, 0, 0, 0, 0])
r = Register.new(ip, start)
instructions = input.map do |line|
  arr = line.split(" ")
  [arr[0]] + arr[1..3].map(&:to_i)
end

# instructions.each_with_index do |i, n|
#   p "#{n}. " + r.send("#{i[0]}_say", *i[1..3])
# end

rounds = 0
# 1000.times do 
loop do
  rounds += 1
  instruct = instructions[r.pointer]
  print "##{r.pointer} - "
  print r.send("#{instruct[0]}_say", instruct[1], instruct[2], instruct[3])
  print "\n"
  r.send(*instruct)
  p r.regs
  if r.pointer == 3
    p r.regs
  end
  break unless r.pointer + 1 < instructions.length
  p "-----"
  r.tick
end
p "----end----"
p r.regs
p rounds