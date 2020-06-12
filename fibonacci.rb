def fibs(x)
  f = []
  n = 1
  while n <= x
    if n == 1
      f.push(0)
    elsif n == 2
      f.push(1)
    elsif n > 2
      f.push(f[-1] + f[-2])
    end
    n += 1
  end
  return f
end

def fibs_rec(x)
  return (x == 1)? [0] 
    : (x == 2)? [0, 1][0, x] 
    : fibs_rec(x-1) + [fibs_rec(x-1)[-1] + fibs_rec(x-1)[-2]]
end