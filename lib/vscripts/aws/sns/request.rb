#require 'json'
#require_relative 'notification'
#require_relative '../../aws'
# FIXME: Untested
module VScripts
  module AWS
    module SNS
      # Request Class
      # Processes AWS SNS Requests
      class Request
        include VScripts::AWS

        # @return [String] the type
        attr_reader :type
        # @return [String] the body
        attr_reader :body
        # @return [String] the topic ARN
        attr_reader :topic_arn
        # @return [String] the token
        attr_reader :token
        # @return [String] the time stamp
        attr_reader :time_stamp
        # @return [String] the subject
        attr_reader :subject

        # Process environment variables and parses the body of the message
        # @param env [Hash] the environment variables
        # @param body [String] the body
        def initialize(env, body)
          @type = env['HTTP_X_AMZ_SNS_MESSAGE_TYPE'].downcase.to_sym
          @body = JSON.parse(body)
        end

        # @return [String] the topic ARN
        def topic_arn
          body['TopicArn']
        end

        # @return [String] the token
        def token
          body['Token']
        end

        # @return [String] the time stamp
        def time_stamp
          body['Timestamp']
        end

        # @return [String] the subject
        def subject
          body['Subject']
        end

        # Analyzes the message only if it's authentic
        def analyze
          send type if ::AWS::SNS::Message.new(body).authentic?
        rescue
          puts 'Unauthorized message received (ignoring).'
        end

        # Confirms subscription
        def subscriptionconfirmation
          confirm_subscription(topic_arn, token)
        end

        ## Analyzes the message if it is a notification
        #def notification
          #Notification.new(body).execute
        #end

        ## Unsubcribes (not yet implemented)
        #def unsubscribeconfirmation
          #puts 'Unsubscribe confirmation received (ignoring).'
        #end
      end # class Request
    end # module SNS
  end # module AWS
end # module VScripts
