class Elf
  attr_accessor :task

  def tasked?
    !task.nil?
  end

  def finished?
    task.seconds <= 0
  end

  def reset
    self.task.status = :finished
    self.task = nil
  end

  def ==(a)
    task.name == a.name
  end

  def set(t)
    self.task = t
    t.status = :assigned
  end
end