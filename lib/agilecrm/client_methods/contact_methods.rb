module AgileCRM
  module ClientMethods
    module ContactMethods

      def contacts(params = {})
        rest_api_get('contacts', params).body || []
      end

      def find_contact(contact_id)
        rest_api_get("contacts/#{contact_id}").body
      end

      def find_contact!(contact_id)
        find_contact(contact_id) || raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for ID '#{contact_id}'")
      end

      def find_contact_by_email(email)
        php_api_get('contact', email: email).body
      end

      def find_contact_by_email!(email)
        find_contact_by_email(email) || raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for email '#{email}'")
      end

      def create_contact(params = {})
        params.delete :id
        save_contact params
      end

      def update_contact(contact_id, params = {})
        params[:id] = contact_id
        save_contact params
      end

      def save_contact(params = {})
        method = params[:id].present? ? :put : :post
        rest_api_request(method, 'contacts', params).body
      end

      def destroy_contact(contact_id)
        rest_api_delete("contacts/#{contact_id}").success?
      end

    end
  end
end