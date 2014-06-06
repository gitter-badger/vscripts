require 'spec_helper'
require 'vscripts/aws/metadata'

describe VScripts::AWS::Metadata do
  before(:each) do
    @dummy = DummyClass.new
    @dummy.extend VScripts::AWS::Metadata
    allow(@dummy).to receive_message_chain('open.read')
      .and_return('Remote server response')
  end

  describe '#metadata_url' do
    it 'returns metadata url string' do
      expect(@dummy.metadata_url).to be_a String
    end
  end

  describe '#zone' do
    it 'returns zone string' do
      expect(@dummy.zone).to eq('Remote server response')
    end
  end

  describe '#region' do
    it 'returns region string' do
      allow(@dummy).to receive(:zone).and_return('us-test-1a')
      expect(@dummy.region).to eq('us-test-1')
    end
  end

  describe '#instance_id' do
    it 'returns instance id string' do
      expect(@dummy.instance_id).to eq('Remote server response')
    end
  end

  describe '#public_hostname' do
    it 'returns public hostname string' do
      expect(@dummy.public_hostname).to eq('Remote server response')
    end
  end

  describe '#ec2_instance?' do
    it 'returns true if metadata accessible' do
      allow(Net::HTTP).to receive(:get_response).and_return(true)
      expect(@dummy.ec2_instance?).to be true
    end
    it 'returns false if metadata not accessible' do
      allow(Net::HTTP).to receive(:get_response).and_raise(StandardError)
      expect(@dummy.ec2_instance?).to be false
    end
  end

  describe '#check_instance' do
    it 'exits if not ec2 instance' do
      $stderr = StringIO.new
      allow(@dummy).to receive(:ec2_instance?).and_return(false)
      expect { @dummy.check_instance }.to raise_error(SystemExit)
      $stderr = STDERR
    end
  end
end