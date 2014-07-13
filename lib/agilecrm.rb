require 'agilecrm/client'

module AgileCRM

  mattr_accessor :domain, :username, :apikey, :adapter

  class << self
    def client
      @client || reload_client
    end

    def configure
      yield self
      reload_client
    end

    private

      def reload_client
        options = {}
        options[:adapter] = adapter if adapter
        @client = AgileCRM::Client.new domain, username, apikey, options
      end
  end
end