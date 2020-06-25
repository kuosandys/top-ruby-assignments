class Calculator
  def add(*args)
    args.reduce(0, :+)
  end

  def multiply(a, b)
    a * b
  end
end