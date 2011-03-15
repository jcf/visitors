class Hash
  if instance_methods.include?(:deep_merge)
    warn 'Hash#deep_merge already defined!'
  else
    def deep_merge(other_hash)
      dup.deep_merge!(other_hash)
    end
  end

  if instance_methods.include?(:deep_merge!)
    warn 'Hash#deep_merge! already defined!'
  else
    def deep_merge!(other_hash)
      other_hash.each_pair do |k,v|
        tv = self[k]
        self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_merge(v) : v
      end
      self
    end
  end
end
