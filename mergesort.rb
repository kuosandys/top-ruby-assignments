def merge_sort(ary)
  if ary.length < 2
    return ary
  else
    result = []
    mid = ((ary.length / 2) - 1).floor
    left = merge_sort(ary[0..mid])
    right = merge_sort(ary - left)
    until left.empty? || right.empty?
      if left[0] < right[0]
        result.push(left.shift)
      else
        result.push(right.shift)
      end
    end
    return result + left + right
  end
end