require "cloud_model/config_modules/api"

module CloudModel
  module Api
    module Desec
      class Config
        attr_accessor :tokens

        def token_for(name)
          tokens[name]
        end
      end
    end
  end
end

module CloudModel::Api::Desec::ConfigInclude
  def desec
    @desec ||= CloudModel::Api::Desec::Config.new
  end
end

CloudModel::ConfigModules::Api.class_eval { include CloudModel::Api::Desec::ConfigInclude }