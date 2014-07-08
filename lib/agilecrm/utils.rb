module AgileCRM
  module Utils
    class << self
      # ActiveSupport 4.0+ like merging with block
      def deep_merge(hash_a, hash_b, &block)
        hash_a = hash_a.dup
        hash_b.each_pair do |k, v|
          tv = hash_a[k]
          if tv.is_a?(Hash) && v.is_a?(Hash)
            hash_a[k] = deep_merge(tv, v, &block)
          else
            hash_a[k] = block && tv ? block.call(k, tv, v) : v
          end
        end
        hash_a
      end

      def deep_dup(object)
        if object.is_a?(Array)
          object.map { |o| deep_dup o }
        elsif object.is_a?(Hash)
          object = object.dup
          object.each_pair do |k, v|
            object[deep_dup(k)] = deep_dup v
          end
        elsif [NilClass, FalseClass, TrueClass, Symbol, Numeric].detect{ |klass| object.is_a? klass } && !object.is_a?(BigDecimal)
          object
        else
          object.dup
        end
      end
    end
  end
end