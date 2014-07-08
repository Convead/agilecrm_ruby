require 'faraday'

module AgileCRM
  module Response
    class ParseJson < Faraday::Response::Middleware

      WHITESPACE_REGEX = /\A^\s*$\z/
      PARSABLE_STATUS_CODES = [200, 201, 204]

      def parse(body)
        case body
        when WHITESPACE_REGEX, nil
          nil
        else
          JSON.parse body, symbolize_names: true
        end
      end

      def on_complete(response)
        response.body = parse(response.body) if PARSABLE_STATUS_CODES.include?(response.status)
      end

    end
  end
end
