module CloudModel
  module Api
    module Desec
      class Dns
        #get all DNS entries for supported domains from deSEC
        def self.all
          result = {}
          CloudModel.config.api.desec.tokens.keys.each do |domain|
            result[domain] ||= {}
            result[domain] = CloudModel::Api::Desec.request_get domain, 'rrsets/'
          end
          result
        end

        # set given resolutions to deSEC; delete entry if addresses are empty
        def self.set domain, resolutions
          records = []

          resolutions.each do |name, addresses|
            v4addresses = []
            v6addresses = []

            addresses.each do |address|
              if address.is_a? String
                address = CloudModel::Address.from_str address
              end

              if address.ip_version == 6
                v6addresses << address.ip
              else
                v4addresses << address.ip
              end
            end

            records << {subname: name, type: "A", ttl: 3600, records: v4addresses}
            records << {subname: name, type: "AAAA", ttl: 3600, records: v6addresses}
          end

          if records.blank?

          else
            CloudModel::Api::Desec.request_put domain, 'rrsets/', records
          end
        end

        # Sync all A and AAAA entries from deSEC to AddressResolutions
        def self.sync_to_address_resolutions domain
          all(domain).each do |info|
            ip = info['rdns']['ip']

            resolution = CloudModel::AddressResolution.find_or_initialize_by('ip' => ip)
            resolution.name = info['rdns']['ptr']
            put resolution.as_document
            #resolution.save
          end
        end

        # Sync all AddressResolutions that are set to active to deSEC DNS servers
        def self.sync_from_address_resolutions
          mappings = {}
          CloudModel::AddressResolution.each do |resolution|
            name, domain = resolution.name.split(/([\w\-]+\.\w{2,10})\z/)

            if CloudModel.config.api.desec.tokens.keys.include? domain
              if name.blank?
                name = ''
              else
                name = name.gsub(/\.$/, '')
              end

              mappings[domain] ||= {}
              mappings[domain][name] ||= []
              if resolution.active?
                mappings[domain][name] << resolution.ip
              end
            end
          end

          CloudModel.config.api.desec.tokens.keys.each do |domain|
            unless mappings[domain].blank?
              pp mappings[domain]
              CloudModel::Api::Desec::Dns.set domain, mappings[domain]
            end
          end
        end
      end
    end
  end
end
