module AgileCRM
  module ClientMethods
    module DealMethods

      def deals(params = {})
        rest_api_get('opportunity', params).body || []
      end

      def find_deal(deal_id)
        rest_api_get("opportunity/#{deal_id}").body
      end

      def find_deal!(deal_id)
        rest_api_get("opportunity/#{deal_id}").body || raise(AgileCRM::Error::ResourceNotFound, "API returned empty result for ID '#{deal_id}'")
      end

      def create_deal(params = {})
        params.delete :id
        save_deal params
      end

      def update_deal(deal_id, params = {})
        params[:id] = deal_id
        save_deal params
      end

      def save_deal(params = {})
        method = params[:id].present? ? :put : :post
        rest_api_request(method, 'opportunity', params).body
      end

      def destroy_deal(deal_id)
        rest_api_delete("opportunity/#{deal_id}").success?
      end

      def deals_where_contact_email(email)
        response = php_api_get('deal', email: email)
        # Currently there are extra escaped quotes in response so that json can not be parsed correctly in ParseJson middleware
        response.body ? response.body.map{ |d| d.is_a?(String) ? JSON.parse(d, symbolize_names: true) : d } : []
      end

    end
  end
end