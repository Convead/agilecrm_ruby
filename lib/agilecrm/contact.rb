require 'agilecrm/abstract_object'
require 'agilecrm/object_methods/has_properties'
require 'agilecrm/object_methods/has_tags'

module AgileCRM
  class Contact < AbstractObject
    include AgileCRM::ObjectMethods::HasProperties
    include AgileCRM::ObjectMethods::HasTags

    class << self

      def all(params = {})
        AgileCRM.client.contacts(params).map { |hash| new hash }
      end

      def find(id)
        hash = AgileCRM.client.find_contact id
        hash ? new(hash) : nil
      end

      def find!(id)
        new AgileCRM.client.find_contact!(id)
      end

      def find_by_email(email)
        hash = AgileCRM.client.find_contact_by_email email
        hash ? new(hash) : nil
      end

      def find_by_email!(email)
        new AgileCRM.client.find_contact_by_email!(email)
      end

    end

    def save
      hash = AgileCRM.client.save_contact to_params
      if hash
        assign_attributes hash
        return true
      else
        return false
      end
    end

    def destroy
      id ? AgileCRM.client.destroy_contact(id) : true
    end

    def to_params
      super.except :cursor, :count, :updated_time, :viewed_time, :viewed, :owner
    end

  end
end