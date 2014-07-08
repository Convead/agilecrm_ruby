require 'faraday'
require 'agilecrm/error'

module AgileCRM
  module Response
    class RaiseError < Faraday::Response::Middleware

      def on_complete(response)
        status = response.status.to_i
        if status >= 400
          klass = AgileCRM::Error::APIError.errors[status] || AgileCRM::Error::APIError
          raise klass.new("Server responded with status #{status}", status, response)
        end
      end

    end
  end
end
