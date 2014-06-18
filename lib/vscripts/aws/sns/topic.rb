# FIXME: Untested

require 'uri'

require_relative '../../system'
require_relative '../../aws'

# Ensure the existence of the specified SNS topics
class Topic
  # @return[String] Topic's name
  attr_reader :topic_name

  def initialize(name)
    @topic_name = name
  end

  # @return[String] Endpoint url.
  def endpoint
    "http://#{local_fqdn}:8523/sns"
  end

  # @return[AWS::SNS::Topic] The topic object (creates it if non existent)
  def topic
    sns.topics
      .select { |topic| topic if topic.name == topic_name }
      .first || create_topic
  end

  # @return[AWS::SNS::Topic] New topic object
  def create_topic
    puts "Creating topic \"#{topic_name}\""
    sns.topics.create(topic_name)
  end

  # @return[AWS::SNS::Subscription] The subscription
  def subscription
    topic.subscriptions
      .select { |subscr| subscr if correct?(subscr) }.first || false
  end

  # @return[Boolean] Ensures the correct subscription
  def correct?(subscr)
    subscr.protocol == :http &&
      subscr.endpoint == endpoint &&
      subscr.arn != 'PendingConfirmation'
  end

  # Subscribe to specified topic
  def subscribe
    unless subscription
      puts "Subscribing to topic \"#{topic_name}\""
      topic.subscribe(URI.parse(endpoint))
    end
  end

  # Unsubscribe from specified topic
  def unsubscribe
    if subscription
      puts "Removing subscription to topic \"#{topic_name}\""
      sns.client.unsubscribe(subscription_arn: subscription.arn)
    end
  rescue
    puts 'Could not unsubscribe'
  end
end # class Endpoint
