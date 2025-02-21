require 'spec_helper'
require 'cloud_model/api/desec/address_resolution'

describe CloudModel::Api::Desec::AddressResolution do
  subject {CloudModel::AddressResolution.new}

  describe '.update_desec_dns_names' do
    before do
      allow(CloudModel::Api::Desec::Dns).to receive :set
    end

    it "should set dns" do
      CloudModel::AddressResolution.create ip: '10.42.23.1', name: 'test.example.com', active: true

      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {'test' => ['10.42.23.1']})
      subject.name = 'test.example.com'
      subject.ip = '127.0.0.1'

      subject.update_desec_dns_names ['test.example.com']
    end

    it "should set dns on multiple address resolutions for name" do
      CloudModel::AddressResolution.create ip: '10.42.23.1', name: 'test.example.com', active: true
      CloudModel::AddressResolution.create ip: '10.42.23.2', name: 'test.example.com', active: true

      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {'test' => ['10.42.23.1', '10.42.23.2']})
      subject.name = 'test.example.com'
      subject.ip = '127.0.0.1'

      subject.update_desec_dns_names ['test.example.com']
    end

    it "should set dns on multiple address resolutions for name" do
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {"test"=>["10.42.23.1"], "test42"=>["10.42.23.1"]})
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.org', {"test42"=>["10.42.23.1"]})
      CloudModel::AddressResolution.create ip: '10.42.23.1', name: 'test42.example.com', alt_names: ['test.example.com', 'test42.example.org'], active: true


      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {"test"=>["10.42.23.1", "10.42.23.2"], "test23"=>["10.42.23.2"]})
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.org', {"test23"=>["10.42.23.2"]})
      CloudModel::AddressResolution.create ip: '10.42.23.2', name: 'test23.example.com', alt_names: ['test.example.com', 'test23.example.org'], active: true

      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {"test"=>["10.42.23.1", "10.42.23.2"], "test23"=>["10.42.23.2"], "test42"=>["10.42.23.1"]})
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.org', {"test23"=>["10.42.23.2"], "test42"=>["10.42.23.1"]})

      subject.name = 'test.example.com'
      subject.ip = '127.0.0.1'

      subject.update_desec_dns_names ['test.example.com', 'test23.example.com', 'test42.example.com', 'test23.example.org', 'test42.example.org']
    end

    it "should not set dns if domain has no api key" do
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.com', {"test"=>["10.42.23.1"]})
      expect(CloudModel::Api::Desec::Dns).to receive(:set).with('example.org', {"test"=>["10.42.23.1"]})
      expect(CloudModel::Api::Desec::Dns).not_to receive(:set).with('example.gov', {"test"=>["10.42.23.1"]})
      CloudModel::AddressResolution.create ip: '10.42.23.1', name: 'test.example.gov', alt_names: ['test.example.com', 'test.example.org'], active: true
    end
  end

  describe '.set_desec_dns' do
    it 'is called when AddressResolution is saved' do
      subject.name = 'test.example.com'
      subject.ip = '127.0.0.1'

      expect(subject).to receive(:set_desec_dns).and_yield {true}
      subject.save!
    end

    it 'updates DNS when name is changed' do
      subject.name = 'test.example.com'
      subject.ip = '127.0.0.1'

      allow(subject).to receive(:name_changed?).and_return true
      allow(subject).to receive(:update_desec_dns_names)

      result = subject.set_desec_dns { true }

      expect(subject).to have_received(:update_desec_dns_names).with(['test.example.com'])
      expect(result).to be_truthy
    end

    it 'updates DNS when alt_names is changed' do
      subject.name = 'test.example.com'
      subject.alt_names = ['test23.example.com', 'test42.example.com', 'foo@example.org']
      subject.ip = '127.0.0.1'

      allow(subject).to receive(:name_changed?).and_return false
      allow(subject).to receive(:alt_names_changed?).and_return true
      allow(subject).to receive(:update_desec_dns_names)

      result = subject.set_desec_dns { true }

      expect(subject).to have_received(:update_desec_dns_names).with(['test.example.com', "test23.example.com", "test42.example.com", "foo@example.org"])
      expect(result).to be_truthy
    end

    it 'updates DNS for old name, too' do
      subject.name = 'test.example.com'
      allow(subject).to receive(:name_was).and_return 'test23.example.com'
      subject.ip = '127.0.0.1'

      allow(subject).to receive(:name_changed?).and_return true
      allow(subject).to receive(:update_desec_dns_names)

      result = subject.set_desec_dns { true }

      expect(subject).to have_received(:update_desec_dns_names).with(["test23.example.com", 'test.example.com'])
      expect(result).to be_truthy
    end

    it 'updates DNS for old alt_names, too' do
      subject.name = 'test.example.com'
      allow(subject).to receive(:name_was).and_return 'test.example.com'

      subject.alt_names = ['test42.example.com', 'test23.example.com']
      allow(subject).to receive(:alt_names_was).and_return ['test21.example.com', 'test23.example.com']
      subject.ip = '127.0.0.1'

      allow(subject).to receive(:name_changed?).and_return false
      allow(subject).to receive(:update_desec_dns_names)

      result = subject.set_desec_dns { true }

      expect(subject).to have_received(:update_desec_dns_names).with(["test.example.com", "test42.example.com", "test23.example.com"])
      expect(result).to be_truthy
    end
  end

  describe '.destroy_desec_dns' do
    it 'is called when AddressResolution is destroyed' do
      expect(subject).to receive :destroy_desec_dns
      subject.destroy
    end

    it 'removes DNS records on destroy' do
      allow(subject).to receive(:name_was).and_return 'test.example.com'
      allow(subject).to receive(:update_desec_dns_names)

      result = subject.destroy_desec_dns { true }

      expect(subject).to have_received(:update_desec_dns_names).with(['test.example.com'])
      expect(result).to be_truthy
    end
  end
end