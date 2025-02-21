require "cloud_model/api/desec/engine"

Rails.application.routes.draw do
  mount CloudModel::Api::Desec::Engine => "/cloud_model-api-desec"
end
