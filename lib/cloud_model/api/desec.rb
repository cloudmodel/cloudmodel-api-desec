require "cloudmodel"
#require "cloud_model/engine"

# if Rails.env.test?
#   require "cloud_model/api/desec/engine"
# end
require "cloud_model/api/desec/config"
require "cloud_model/api/desec/dns"
require "cloud_model/api/desec/address_resolution"

module CloudModel
  module Api
    module Desec
      def self.send_request domain, request
        request['Authorization'] = "Token #{CloudModel.config.api.desec.token_for(domain)}"
        request['Content-Type'] = 'application/json'

        http = Net::HTTP.new(request.uri.host, request.uri.port)
        http.use_ssl = true

        response = http.request request

        if response.kind_of? Net::HTTPSuccess
          begin
            JSON.parse response.body
          rescue
            response.body
          end
        else
          puts "error #{response.code}: #{response.body}"
          false
        end
      end

      def self.request_get domain, action
        uri = URI("https://desec.io/api/v1/domains/#{domain}/#{action}")
        send_request domain, Net::HTTP::Get.new(uri)
      end

      def self.request_delete domain, action
        uri = URI("https://desec.io/api/v1/domains/#{domain}/#{action}")
        send_request domain, Net::HTTP::Delete.new(uri)
      end

      def self.request_post domain, action, data
        uri = URI("https://desec.io/api/v1/domains/#{domain}/#{action}")
        request = Net::HTTP::Post.new(uri)
        request.body = data.to_json
        send_request domain, request
      end

      def self.request_put domain, action, data
        uri = URI("https://desec.io/api/v1/domains/#{domain}/#{action}")
        request = Net::HTTP::Put.new(uri)
        request.body = data.to_json
        send_request domain, request
      end

      def self.request_patch domain, action, data
        uri = URI("https://desec.io/api/v1/domains/#{domain}/#{action}")
        request = Net::HTTP::Patch.new(uri)
        request.body = data.to_json
        send_request domain, request
      end
    end
  end
end