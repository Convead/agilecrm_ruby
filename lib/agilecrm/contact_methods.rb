module AgileCRM
  module ContactMethods

    def contacts(params = {})
      rest_api_get('contacts', params).body
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

    def create_contact(base_params = {}, properties = {})
      base_params.delete :id
      params = normalize_contact_save_params(base_params, properties)
      save_contact params
    end

    def update_contact(contact_id, base_params = {}, properties = {})
      reject_old_params_keys = [:owner, :updated_time]
      old_params = find_contact!(contact_id).reject{ |k, v| reject_old_params_keys.include?(k) }
      new_params = normalize_contact_save_params(base_params, properties)
      params = Utils.deep_merge old_params, new_params do |key, old_value, new_value|
        if key == :properties && old_value.is_a?(Array) && new_value.is_a?(Array)
          old_value.select{ |o| !new_value.detect{ |n| o[:name] == n[:name] } } + new_value
        else
          new_value
        end
      end
      save_contact params
    end

    def save_contact(params = {})
      method = params[:id].present? ? :put : :post
      rest_api_request(method, 'contacts', params).body
    end

    def delete_contact(contact_id)
      rest_api_delete("contacts/#{contact_id}").success?
    end

    def add_tags(contact_id, tags)
      contact = find_contact! contact_id
      # Currently API allows to add tags only by email.
      email = detect_contact_property :email, contact
      raise(AgileCRM::Error::EmptyArgumentError, "Contact #{contact_id} doesn't have email") if email.nil? || email.strip.empty?
      add_tags_by_email email, tags
    end

    def add_tags_by_email(email, tags)
      tags = tags.join(', ') if tags.is_a?(Array)
      response = php_api_post('tags', email: email, tags: tags)
      raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for email '#{email}'") unless response.status == 200
      response.body
    end

    def remove_tags(contact_id, tags)
      contact = find_contact! contact_id
      # Currently API allows to remove tags only by email.
      email = detect_contact_property :email, contact
      raise(AgileCRM::Error::EmptyArgumentError, "Contact #{contact_id} doesn't have email") if email.nil? || email.strip.empty?
      remove_tags_by_email email, tags
    end

    def remove_tags_by_email(email, tags)
      tags = tags.join(', ') if tags.is_a?(Array)
      response = php_api_put('tags', email: email, tags: tags)
      raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for email '#{email}'") unless response.status == 200
      response.body
    end

    private

      def normalize_contact_save_params(base_params = {}, properties = {})
        params = Utils.deep_dup base_params
        params[:properties] ||= []
        params[:properties] += properties.map{ |k, v| {name: k.to_s, value: v.to_s} }
        params
      end

      def detect_contact_property(property_name, params = {})
        Array.wrap(params[:properties]).detect{ |p| p[:name] == property_name.to_s }.try :[], :value
      end

  end
end