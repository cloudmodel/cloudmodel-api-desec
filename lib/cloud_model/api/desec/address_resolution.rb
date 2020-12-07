begin
  CloudModel::AddressResolution
rescue
  require File.expand_path('../../app/models/cloud_model/address_resolution', CloudModel::Engine.called_from)
end

module CloudModel
  module Api
    module Desec
      module AdressResolution
        def self.included(base)
          base.extend ClassMethods
          base.around_save :set_desec_dns
          base.around_destroy :destroy_desec_dns
        end

        module ClassMethods
        end

        def update_desec_dns_names names
          mappings = {}

          names.each do |n|
            sub_name, domain = n.split(/([\w\-]+\.\w{2,10})\z/)
            sub_name = sub_name.gsub(/\.$/, '')

            mappings[domain] ||= {}
            mappings[domain][sub_name] = CloudModel::AddressResolution.where(name: n, active: true).pluck(:ip)
          end
          CloudModel.config.api.desec.tokens.keys.each do |domain|
            unless mappings[domain].blank?
              pp mappings[domain]
              CloudModel::Api::Desec::Dns.set domain, mappings[domain]
            end
          end
        end

        def set_desec_dns
          name_changed = name_changed?
          names = []
          names << name_was unless name_was.nil?
          if result = yield and name_changed
            begin
              names << name
              update_desec_dns_names names
            rescue
            end
          end

          result
        end

        def destroy_desec_dns
          name_changed = name_changed?
          names = [name_was]
          if result = yield
            begin
              update_desec_dns_names names
            rescue
            end
          end

          result
        end
      end
    end
  end
end

CloudModel::AddressResolution.class_eval { include CloudModel::Api::Desec::AdressResolution }
