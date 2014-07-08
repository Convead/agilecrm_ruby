module AgileCRM
  class Error < StandardError

    class ArgumentError < self; end

    class EmptyArgumentError < ArgumentError; end
    
    class APIError < self
      attr_reader :code, :response

      def self.errors
        @errors ||= {
          400 => AgileCRM::Error::BadRequest,
          401 => AgileCRM::Error::Unauthorized,
          404 => AgileCRM::Error::ResourceNotFound,
          405 => AgileCRM::Error::InvalidMethodType,
          415 => AgileCRM::Error::UnsupportedMediaType,
          500 => AgileCRM::Error::InternalServerError,
          502 => AgileCRM::Error::BadGateway,
          503 => AgileCRM::Error::ServiceUnavailable,
          504 => AgileCRM::Error::GatewayTimeout
        }
      end

      def initialize(message = '', code = nil, response = nil)
        super message
        @response = response
        @code = code
      end
    end

    class ClientError < APIError; end

    class BadRequest < ClientError; end

    class Unauthorized < ClientError; end

    class ResourceNotFound < ClientError; end

    class InvalidMethodType < ClientError; end

    class UnsupportedMediaType < ClientError; end

    class ServerError < APIError; end

    class InternalServerError < ServerError; end

    class BadGateway < ServerError; end

    class ServiceUnavailable < ServerError; end

    class GatewayTimeout < ServerError; end

  end
end