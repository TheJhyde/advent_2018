class Formula
  attr_accessor :formula

  def initialize(formula={})
    self.formula = formula
    self.formula[:integer] ||= 0
  end

  def variables
    self.formula.keys - [:integer]
  end

  def known?
    self.variables.length == 0
  end

  def +(addor)
    if addor.is_a?(Integer)
      f = Formula.new(self.formula.dup)
      f.formula[:integer] += addor
      return f
    elsif addor.is_a?(Formula)
      Formula.new(formula.merge(addor.formula) {|k, o, n| o+n})
    end
  end

  def *(multiple)
    if multiple.is_a?(Integer)
      Formula.new(formula.merge(formula) {|k, v| v * multiple})
    elsif multiple.is_a?(Formula)
      f = self * multiple.formula[:integer]
      multiple.variables.each do |a|
        new_formula = {}
        variables.each do |b|
          new_formula["#{b}#{a}".to_sym] = formula[b] * multiple.formula[a]
        end
        new_formula[a] = multiple.formula[a] * formula[:integer]
        f += Formula.new(new_formula)
      end
      f.formula = f.formula.delete_if{|k, v| v == 0 && k != :integer}
      f
    end
  end

  def resolve(values)
    self.formula[:integer] + self.variables.reduce(0) do |acc, k|
      var = k.to_s.split("").reduce(1) {|acc, v| acc * values[v.to_sym]}
      acc += var * formula[k]
    end
  end

  def to_s
    string = formula.map {|v| "#{(v[0] != :integer && v[1] == 1) || (v[0] == :integer && v[1] == 0) ? '' : v[1]}#{v[0] == :integer ? '' : v[0]}"}.reject{|a| a == ''}.join(" + ")
    string == '' ? "0" : string
  end

  def inspect
    string = formula.map {|v| "#{(v[0] != :integer && v[1] == 1) || (v[0] == :integer && v[1] == 0) ? '' : v[1]}#{v[0] == :integer ? '' : v[0]}"}.reject{|a| a == ''}.join(" + ")
    string == '' ? "0" : string
  end
end