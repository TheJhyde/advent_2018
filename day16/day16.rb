require 'set'

class Register
  [["add", :+], ["mul", :*], ["ban", :&], ["bor", :|]].each do |instr|
    define_singleton_method "#{instr[0]}r" do |regs, a, b, c|
      regs[c] = regs[a].send(instr[1], regs[b])
      regs
    end

    define_singleton_method "#{instr[0]}i" do |regs, a, b, c|
      regs[c] = regs[a].send(instr[1], b)
      regs
    end
  end

  def self.setr(regs, a, b, c)
    regs[c] = regs[a]
    regs
  end

  def self.seti(regs, a, b, c)
    regs[c] = a
    regs
  end

  {gt: :>, eq: :==}.each do |k, v|
    define_singleton_method "#{k}ir" do |regs, a, b, c|
      regs[c] = a.send(v, regs[b]) ? 1 : 0
      regs
    end

    define_singleton_method "#{k}ri" do |regs, a, b, c|
      regs[c] = regs[a].send(v, b) ? 1 : 0
      regs
    end

    define_singleton_method "#{k}rr" do |regs, a, b, c|
      regs[c] = regs[a].send(v, regs[b]) ? 1 : 0
      regs
    end
  end
end

input = File.read("input1.txt").split("\n\n").map {|n| n.split("\n")}

ops = [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr].freeze

count = 0
input.each do |test_case|
  matches = 0
  before = test_case[0].scan(/\d+/).map(&:to_i).freeze
  input = test_case[1].scan(/\d+/).map(&:to_i).freeze
  after = test_case[2].scan(/\d+/).map(&:to_i).freeze

  matches = ops.count do |op|
    r = Register.send(op, before.dup, input[1], input[2], input[3])
    r == after
  end
  count += matches >= 3 ? 1 : 0
end
p count

input = File.read("input1.txt").split("\n\n").map {|n| n.split("\n")}
codes = Array.new(16) {ops.dup}
input.each do |test_case|
  matches = 0
  before = test_case[0].scan(/\d+/).map(&:to_i).freeze
  input = test_case[1].scan(/\d+/).map(&:to_i).freeze
  after = test_case[2].scan(/\d+/).map(&:to_i).freeze

  codes[input[0]].select! do |op|
    r = Register.send(op, before.dup, input[1], input[2], input[3])
    r == after
  end
end

op_codes = Array.new(16)
loop do
  codes.each_with_index do |code, i|
    if code.length == 1
      op_codes[i] = code[0]
    end
    code.reject! {|c| op_codes.include?(c)}
  end
  break if codes.all? {|c| c.length == 0}
end

input2 = File.readlines("input2.txt").map {|n| n.scan(/\d+/).map(&:to_i)}
reg = [0, 0, 0, 0]
output = input2.reduce([0, 0, 0, 0]) do |reg, input|
  Register.send(op_codes[input[0]], reg, input[1], input[2], input[3])
end

p output
