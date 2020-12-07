module CloudModel
  module Api
    module Desec
      class Engine < ::Rails::Engine
        isolate_namespace CloudModel::Api::Desec
      end
    end
  end
end
