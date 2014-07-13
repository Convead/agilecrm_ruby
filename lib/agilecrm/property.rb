require 'json'
require 'agilecrm/abstract_object'
require 'agilecrm/utils'

module AgileCRM
  class Property < AbstractObject
  
    TYPES = {
      address: 'AgileCRM::AddressProperty'
    }

    class << self
      def from_hash(hash)
        if hash[:name] && class_name = TYPES[hash[:name].to_sym]
          class_name.constantize.new hash
        else
          new hash
        end
      end
    end

    def eql?(property_or_hash)
      hash = property_or_hash.is_a?(Property) ? property_or_hash.attributes : property_or_hash
      attributes == hash
    end

    def include?(property_or_hash)
      hash = property_or_hash.is_a?(Property) ? property_or_hash.attributes : property_or_hash
      Utils.hash_include? attributes, hash
    end

  end

  class AddressProperty < Property

    def assign_attributes(hash)
      super
      @attributes[:value] = (JSON.parse(@attributes[:value], symbolize_names: true) rescue {}) unless @attributes[:value].is_a?(Hash)
    end

    def to_params
      p = super
      p.merge!(value: value.to_json) if value.is_a?(Hash)
      p
    end

  end

end