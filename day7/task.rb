class Task
  include Comparable
  attr_accessor :name, :status, :requirements, :seconds

  def initialize(name)
    self.name = name
    self.status = :start
    self.requirements = []
    self.seconds = name.unpack("C")[0] - 4
  end

  def finished?
    status == :finished || seconds == 0
  end

  def can_run?
    status == :start && requirements.all? {|r| r.finished?}
  end

  def <=>(other)
    name <=> other.name
  end

end