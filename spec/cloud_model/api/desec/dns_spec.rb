require 'spec_helper'
require 'cloud_model/api/desec/config'

describe CloudModel::Api::Desec::Dns do
  describe '.set' do
    it 'should set ipv4 addresses' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test2', "type": "A", "ttl": 3600, "records": ['198.51.100.42', '203.0.113.23']}
        ]
      )

      CloudModel::Api::Desec::Dns.set 'example.com', 'test2' => ['198.51.100.42', '203.0.113.23']
    end

    it 'should set ipv6 addresses' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test2', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::dead:beef', '2001:db8::f00:ba2']},
        ]
      )

      CloudModel::Api::Desec::Dns.set 'example.com', 'test2' => ['2001:db8::dead:beef', '2001:db8::f00:ba2']
    end

    it 'should set ipv4 and ipv6 addresses' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test2', "type": "A", "ttl": 3600, "records": ['198.51.100.42', '203.0.113.23']},
          {"subname": 'test2', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::dead:beef', '2001:db8::f00']},
        ]
      )

      CloudModel::Api::Desec::Dns.set 'example.com', 'test2' => ['198.51.100.42', '2001:db8::dead:beef', '2001:db8::f00', '203.0.113.23']
    end

    it 'should set multiple ipv4 resolutions' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test1', "type": "A", "ttl": 3600, "records": ['198.51.100.23']},
          {"subname": 'test2', "type": "A", "ttl": 3600, "records": ['198.51.100.42', '203.0.113.23']}
        ]
      )

      CloudModel::Api::Desec::Dns.set(
        'example.com',
        'test1' => ['198.51.100.23'],
        'test2' => ['198.51.100.42', '203.0.113.23']
      )
    end

    it 'should set mutiple ipv6 resolutions' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test1', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::ba2:f00']},
          {"subname": 'test2', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::dead:beef', '2001:db8::f00:ba2']},
        ]
      )

      CloudModel::Api::Desec::Dns.set(
        'example.com',
        'test1' => ['2001:db8::ba2:f00'],
        'test2' => ['2001:db8::dead:beef', '2001:db8::f00:ba2'],
      )
    end

    it 'should set multiple ipv4 and ipv6 resolutions' do
      expect(CloudModel::Api::Desec).to receive(:request_put).with(
        'example.com',
        'rrsets/',
        [
          {"subname": 'test1', "type": "A", "ttl": 3600, "records": ['198.51.100.23']},
          {"subname": 'test1', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::ba2:f00']},
          {"subname": 'test2', "type": "A", "ttl": 3600, "records": ['198.51.100.42', '203.0.113.23']},
          {"subname": 'test2', "type": "AAAA", "ttl": 3600, "records": ['2001:db8::dead:beef', '2001:db8::f00']},
        ]
      )

      CloudModel::Api::Desec::Dns.set(
        'example.com',
        'test1' => ['198.51.100.23', '2001:db8::ba2:f00'],
        'test2' => ['198.51.100.42', '2001:db8::dead:beef', '2001:db8::f00', '203.0.113.23']
      )
    end
  end
end