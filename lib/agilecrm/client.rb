require 'faraday'
require 'faraday_middleware'
require 'active_support/core_ext/object'
require 'agilecrm/error'
require 'agilecrm/utils'
require 'agilecrm/response/parse_json'
require 'agilecrm/response/raise_error'
require 'agilecrm/contact_methods'
require 'agilecrm/deal_methods'

module AgileCRM
  class Client
    
    include ContactMethods
    include DealMethods

    REST_API_URL_PREFIX = 'agilecrm.com/dev/api'
    PHP_API_URL_PREFIX  = 'agilecrm.com/core/php/api'
    DEFAULT_OPTIONS     = {adapter: :net_http}

    def initialize(domain, username, apikey, options = {})
      @rest_api_endpoint = "https://#{domain}.#{REST_API_URL_PREFIX}"
      @php_api_endpoint  = "https://#{domain}.#{PHP_API_URL_PREFIX}"
      @username          = username
      @apikey            = apikey
      @options           = DEFAULT_OPTIONS.merge options
    end

    private

      def rest_api_connection
        @rest_api_connection ||= Faraday.new @rest_api_endpoint do |c|
          c.headers =  {accept: 'application/json'}
          c.use        FaradayMiddleware::EncodeJson
          c.use        AgileCRM::Response::RaiseError
          c.use        AgileCRM::Response::ParseJson
          c.basic_auth @username, @apikey
          c.adapter    @options[:adapter]
        end
      end

      def php_api_connection
        @php_api_connection ||= Faraday.new @php_api_endpoint do |c|
          c.headers = {accept: 'application/json', content_type: 'application/json'}
          c.use       FaradayMiddleware::EncodeJson
          c.use       AgileCRM::Response::RaiseError
          c.use       AgileCRM::Response::ParseJson
          c.adapter   @options[:adapter]
        end
      end

      %w(rest php).each do |api_type|
        %w(get post put delete).each do |method|
          define_method "#{api_type}_api_#{method}" do |path, params = {}|
            send "#{api_type}_api_request", method, path, params
          end
        end
      end

      def rest_api_request(method, path, params = {})
        rest_api_connection.send method, path, params
      end

      def php_api_request(method, path, params = {})
        # params[:id] = @apikey
        path << "?id=#{@apikey}"
        php_api_connection.send method, path, params
      end

  end
end