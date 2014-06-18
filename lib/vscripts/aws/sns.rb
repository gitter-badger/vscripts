# encoding: UTF-8
require 'vscripts/aws/sns/request'

# FIXME: Untested
module VScripts
  module AWS
    # A collection of methods used for interaction with Amazon Web Service
    # Simple Notification Service.
    module SNS
      # Loads AWS SDK for SNS
      def sns
        ::AWS::SNS.new
      end

      # Confirms subscription
      # @param arn [String] the topic arn
      # @param token [String] the token
      # @return [String] the subscription arn
      def confirm_subscription(arn, token)
        puts 'Subscription confirmation received (confirming).'
        sns.client.confirm_subscription(
          topic_arn: "#{arn}",
          token: "#{token}"
        )
      end

      # Confirms subscription
      # @param env [Hash] the environment variables
      # @param body [String] the body
      def analyze_request(env, body)
        Request.new(env, body).analyze
      end
    end # module SNS
  end # module Amazon
end # module VScripts
