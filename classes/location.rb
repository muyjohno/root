class Location
  include Logic

  attr_reader :name, :logic, :weight

  def initialize(opts = {})
    @name = opts['name']
    @logic = opts['logic']
    @weight = opts['weight'] || 1
    CHECKED[@name] = false
  end

  def description
    "#{name}#{" (#{weight})" if weight != 1}"
  end

  def checked?
    CHECKED[@name]
  end

  def button
    "<a href=\"#\" class=\"full-button\">#{description}</a>"
  end
end
