module Logic
  def accessible?
    return true if logic.nil? || logic.empty?

    calculator.evaluate(@logic, INVENTORY.items)
  end

  def calculator
    @calculator ||= Dentaku::Calculator.new
  end
end
