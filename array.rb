class Array
  def median
    sorted = sort
    if size % 2 == 0
      left = sorted[[(size / 2) - 1,0].max]
      right = sorted[[(size / 2) + 1, size - 1].min]
      (left + right) / 2.0
    else
      sorted[size / 2]
    end
  end

  def last_index(element)
    reversed_index = reverse.index(element)
    reversed_index ? size - reversed_index - 1 : nil
  end
end
