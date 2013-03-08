class Hash
  def compact
    reject {|k,v| k.nil? || v.nil?}
  end

  def compact!
    reject! {|k,v| k.nil? || v.nil?}
  end

  def hash_map(&fun)
    Hash[self.map {|k,v| [k, fun[k,v]]} ]
  end
end
