module AgileCRM
  module DealMethods

    def deals(params = {})
      rest_api_get('opportunity', params).body
    end

    def find_deal(deal_id)
      rest_api_get("opportunity/#{deal_id}").body
    end

    def find_deal!(deal_id)
      rest_api_get("opportunity/#{deal_id}").body || raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for ID '#{deal_id}'")
    end

    def create_deal(params = {})
      rest_api_post('opportunity', params).body
    end

    def update_deal(deal_id, params = {})
      reject_old_params_keys = [:contacts, :owner, :updated_time]
      old_params = find_deal!(deal_id).reject{ |k, v| reject_old_params_keys.include?(k) }
      params = Utils.deep_merge old_params, params
      rest_api_put('opportunity', params).body
    end

    def delete_deal(deal_id)
      rest_api_delete("opportunity/#{deal_id}").success?
    end

    def contact_deals(contact_id)
      contact = find_contact! contact_id
      email = detect_contact_property :email, contact
      raise(AgileCRM::Error::EmptyArgumentError, "Contact #{contact_id} doesn't have email") if email.nil? || email.strip.empty?
      contact_deals_by_email email
    end

    def contact_deals_by_email(contact_email)
      response = php_api_get('deal', email: contact_email)
      # Currently there are extra escaped quotes in response so that json can not be parsed correctly in ParseJson middleware
      Array.wrap(response.body).map{ |d| d.is_a?(String) ? JSON.parse(d, symbolize_names: true) : d }
    end

  end
end