class String
  def chunk(n)
    (0..length).map {|x| self[x, n] }
  end

  def word_chunk(n)
    safe = split(' ').reject {|word| word.length > n }
    ret_array = [safe.shift]
    safe.each do |word|
      if ret_array.last.length + word.length + 1 <= n
        ret_array[-1] = [ret_array.last, word].join(' ')
      else
        ret_array << word
      end
    end
    ret_array
  end

  def ngram(min, max)
    return [''] if empty?
    (min..max).to_a.map {|n| self.chunk(n) }.flatten.uniq
  end

  def ngram!
    return [''] if empty?
    max = split(' ').sort {|a,b| b.length <=> a.length}.first.length
    ngram(1, max)
  end
end