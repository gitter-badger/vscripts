require 'spec_helper'
require 'vscripts/commands/api'

describe VScripts::Commands::Api do
  subject { VScripts::Commands::Api.new(['start']) }

  describe 'USAGE' do
    it 'returns a String' do
      expect(VScripts::Commands::Api::USAGE).to be_a String
    end
  end

  describe '#new' do
    it 'returns subcommand' do
      expect(subject.command).to be_a String
    end
  end

  describe '#parser' do
    it 'returns Trollop' do
      expect(subject.parser).to be_a Trollop::Parser
    end
  end

  describe '#parse' do
    include_context 'Suppressed output'
    it 'returns cli arguments as a Hash' do
      allow(subject).to receive(:parse_coyymmand)
      expect{subject.parse([])}.to raise_error
    end
  end

  describe '#parse_command' do
    it 'returns subcommand' do
      expect(subject.parse_command(['start'])).to include('start')
    end
  end

  describe '#execute' do
    include_context 'Suppressed output'
    it 'returns an array' do
      allow(VScripts::API).to receive(:run!)
      expect(subject.execute).to be_nil
    end
  end
end
