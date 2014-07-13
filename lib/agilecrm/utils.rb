module AgileCRM
  module Utils
    class << self

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

      def hash_include?(hash, sub_hash)
        sub_hash.keys.all? do |key|
          if hash.has_key?(key) && sub_hash[key].is_a?(Hash)
            hash[key].is_a?(Hash) && hash_include?(hash[key], sub_hash[key])
          else
            hash[key] == sub_hash[key]
          end
        end
      end
    end
  end
end