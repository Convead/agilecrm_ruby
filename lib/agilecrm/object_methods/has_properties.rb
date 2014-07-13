require 'agilecrm/property'

module AgileCRM
  module ObjectMethods
    module HasProperties

      def self.included(base)
        attribute_handler = {
          params_to_attributes: proc { |params|
            params.merge properties: Array.wrap(params[:properties]).map{ |hash| Property.from_hash hash }
          },
          attributes_to_params: proc { |object, attributes|
            attributes.merge properties: object.property_objects.map(&:to_params)
          }
        }
        base.register_attribute_handler attribute_handler
      end

      def properties
        property_objects.map &:attributes
      end

      def property_objects
        attributes[:properties] ||= []
      end

      def add_property(name, value, params = {})
        params.merge! name: name.to_s, value: value
        property_objects << Property.from_hash(params)
        params
      end

      def set_property(name, value, params = {})
        params.merge! name: name.to_s, value: value
        unless property_objects.select{ |prop| prop.eql? params }.length == 1
          property_objects.reject!{ |prop| prop.name == params[:name] }
          property_objects << Property.from_hash(params)
        end
        params
      end

      def remove_property(name, value = nil, params = {})
        params[:name] = name
        params[:value] = value if value
        removed, left = property_objects.partition{ |prop| prop.include? params }
        self.property_objects = left
        removed.map &:attributes
      end

      def get_properties(name, params = {})
        params[:name] = name.to_s
        property_objects.select{ |prop| prop.include? params }.map &:attributes 
      end

      def get_property(name, params = {})
        get_properties(name, params).first
      end

      def get_property_value(name, params = {})
        get_property(name, params).try :[], :value
      end

      def has_property?(name, value = nil, params = {})
        params[:name] = name
        params[:value] = value if value
        !!property_objects.detect{ |prop| prop.include? params }
      end

      private

        def property_objects=(_property_objects)
          attributes[:properties] = _property_objects
        end

    end
  end
end