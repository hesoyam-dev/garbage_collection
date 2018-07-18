
class Obj

  attr_accessor :busy, :created_at

  def initialize(busy:)
    @busy = busy
    @created_at = Time.at((Time.now.to_f - (Time.now - 86400).to_f)*rand + (Time.now - 86400).to_f)
  end

end
