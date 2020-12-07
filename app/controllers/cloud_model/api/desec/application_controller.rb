module CloudModel
  module Api
    module Desec
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
