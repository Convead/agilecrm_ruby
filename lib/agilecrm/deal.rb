require 'agilecrm/abstract_object'

module AgileCRM
  class Deal < AbstractObject

    class << self

      def all(params = {})
        AgileCRM.client.deals(params).map { |hash| new hash }
      end

      def find(id)
        hash = AgileCRM.client.find_deal id
        hash ? new(hash) : nil
      end

      def find!(id)
        new AgileCRM.client.find_deal!(id)
      end

      def where_contact_email(email)
        AgileCRM.client.deals_where_contact_email(email).map{ |hash| new hash }
      end

    end

    def save
      hash = AgileCRM.client.save_deal to_params
      if hash
        assign_attributes hash
        return true
      else
        return false
      end
    end

    def destroy
      id ? AgileCRM.client.destroy_deal(id) : true
    end

    def to_params
      super.except :updated_time, :contacts, :owner
    end

  end
end