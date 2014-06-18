# encoding: UTF-8
require 'aws-sdk'
require 'logger'
require 'yaml'

require 'vscripts/aws/metadata'
require 'vscripts/aws/ec2'
require 'vscripts/aws/sns'

module VScripts
  # A collection of methods used for interaction with Amazon Web Services
  module AWS
    include VScripts::AWS::EC2
    include VScripts::AWS::Metadata
    include VScripts::AWS::SNS

    # @return [AWS::Core::Configuration] the AWS SDK configuration
    def self.configure
      config = VScripts.config.get['AWS'] || {}
      @configure ||= ::AWS.config(config)
    end
  end # module AWS
end # module VScripts
