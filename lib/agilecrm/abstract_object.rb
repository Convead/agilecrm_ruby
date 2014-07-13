require 'agilecrm/utils'

module AgileCRM
  class AbstractObject

    class << self
      def attribute_handlers
        @attribute_handlers ||= []
      end

      def register_attribute_handler(handler)
        attribute_handlers << handler
      end
    end

    def initialize(hash = {})
      assign_attributes hash
    end

    def assign_attributes(hash)
      self.class.attribute_handlers.each do |handler|
        hash = handler[:params_to_attributes].call hash
      end
      @attributes = hash
    end

    def [](attribute)
      attributes[attribute]
    end

    def []=(attribute, value)
      attributes[attribute] = value
    end

    def attributes
      @attributes ||= {}
    end

    def method_missing(method, *args)
      m = method.to_s
      if m[-1, 1] == '='
        self[m[0..-2].to_sym] = args[0]
      else
        self[m.to_sym]
      end
    end

    def to_params
      params = Utils.deep_dup attributes
      self.class.attribute_handlers.each do |handler|
        params = handler[:attributes_to_params].call self, params
      end
      params
    end

    def persisted?
      !!id
    end

  end
end