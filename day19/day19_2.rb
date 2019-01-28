require "./formula.rb"

class RegisterProgram
  attr_accessor :regs, :ip

  def initialize(ip)
    variables = %w(a b c d e f)
    self.regs = variables.map do |v| 
      f = {}
      f[v] = 1
      Formula.new(f)
    end
    self.ip = ip
  end

  def pointer
    self.regs[self.ip]
  end

  def tick
    self.regs[self.ip] += 1
  end

  # ban and bor don't actually appear in my input, so I can safely ignore them for the moment
  [["add", :+, "add"], ["mul", :*, "multiply"], ["ban", :&, "binary and"], ["bor", :|, "binary or"]].each do |instr|
    define_method "#{instr[0]}r" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], self.regs[b])
    end

    define_method "#{instr[0]}i" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], b)
    end
  end

  def setr(a, b, c)
    self.regs[c] = self.regs[a]
  end

  def seti(a, b, c)
    self.regs[c] = Formula.new(integer: a)
  end

  {gt: :>, eq: :==}.each do |k, v|
    define_method "#{k}ir" do |a, b, c|
      self.regs[c] = a.send(v, self.regs[b].resolve({})) ? Formula.new(integer: 1) : Formula.new(integer: 0)
      self.regs
    end

    define_method "#{k}ri" do |a, b, c|
      self.regs[c] = self.regs[a].resolve({}).send(v, b) ? Formula.new(integer: 1) : Formula.new(integer: 0)
      self.regs
    end

    define_method "#{k}rr" do |a, b, c|
      self.regs[c] = self.regs[a].resolve({}).send(v, self.regs[b].resolve({})) ? Formula.new(integer: 1) : Formula.new(integer: 0)
      self.regs
    end
  end
end

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

  def run_formulas(formulas)
    variables = {a: regs[0], b: regs[1], c: regs[2], d: regs[3], e: regs[4], f: regs[5]}
    formulas.each_with_index do |formula, i|
      self.regs[i] = formula.resolve(variables)
    end
    self.regs
end

  [["add", :+, "add"], ["mul", :*, "multiply"], ["ban", :&, "binary and"], ["bor", :|, "binary or"]].each do |instr|
    define_method "#{instr[0]}r" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], self.regs[b])
      self.regs
    end

    define_method "#{instr[0]}i" do |a, b, c|
      self.regs[c] = self.regs[a].send(instr[1], b)
      self.regs
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

  {gt: :>, eq: :==}.each do |k, v|
    define_method "#{k}ir" do |a, b, c|
      self.regs[c] = a.send(v, self.regs[b]) ? 1 : 0
      self.regs
    end

    define_method "#{k}ri" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, b) ? 1 : 0
      self.regs
    end

    define_method "#{k}rr" do |a, b, c|
      self.regs[c] = self.regs[a].send(v, self.regs[b]) ? 1 : 0
      self.regs
    end
  end
end

input = File.read("input.txt").split("\n")
ip = input.shift.scan(/\d/)[0].to_i
instructions = input.map do |line|
  arr = line.split(" ")
  [arr[0]] + arr[1..3].map(&:to_i)
end

operations = []
instructions.each_with_index do |op, i|
  r = RegisterProgram.new(ip)
  r.seti(i, 0, ip)
  # instructions[i..-1].each do |next_op|
  break_reason = ''
  loop do
    next_op = instructions[r.regs[ip].resolve({})]
    if next_op.nil?
      break_reason = "Exceeded instructions"
      break
    end
    if %w(gtir gtrr gtri eqir eqrr eqri).include?(next_op[0])
      if next_op[0].end_with?("ir") && !r.regs[next_op[2]].known?
        break_reason = "Break on: #{next_op.join(" ")}"
        break
      elsif next_op[0].end_with?('rr') && !(r.regs[next_op[1]].known? && r.regs[next_op[2]].known?)
        break_reason = "Break on: #{next_op.join(" ")}"
        break
      elsif !r.regs[next_op[1]].known?
        break_reason = "Break on: #{next_op.join(" ")}"
        break
      end
    end
    r.send(*next_op)
    r.tick
    unless r.regs[ip].known?
      break_reason = "Unknown next step, #{r.regs[ip]}"
      break
    end
  end
  operations << [r.regs, break_reason]
end

# operations.each_with_index do |op, i|
#   print "#{i}: "
#   print op[0].map(&:to_s).join(", ")
#   print " - #{op[1]}"
#   print "\n"
# end

def print_op(op)
  print op.map(&:to_s).join(", ")
  print "\n"
end

r = Register.new(ip, [1, 0, 0, 0, 0, 0])
count = 0
10.times do
  next_f = operations[r.pointer][0]
  break if next_f.nil?
  r.run_formulas(next_f)
  print_op(next_f)
  p r.regs
  p ""

  next_op = instructions[r.pointer]
  break if next_op.nil?
  r.send(*next_op)
  r.tick

  p next_op.join(" ")
  p r.regs

  count += 1
  p r.regs if count % 50000 == 0
end