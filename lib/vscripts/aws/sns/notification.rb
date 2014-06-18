# FIXME: Untested
require 'json'

# Analyzes the body of the message and takes the correct action
class Notification
  # Returns the message
  attr_reader :message
  # Returns the subject
  attr_reader :subject

  def initialize(body)
    @message = body['Message']
    @subject = body['Subject']
  end

  # If the body of the message is consistent with a GitHub service hook
  # it calls the action defined in the configuration.
  # Otherwise it executes the command as is.
  def execute
    if repository_name && repository_branch
      puts 'GitHub service notification received.'
      github_commands.flatten.each { |command| execute_shell(command) }
    else
      puts 'Direct command received.'
      direct_commands.flatten.each { |command| execute_shell(command) }
    end
  end

  # @return[Boolean] Check if message is JSON formatted.
  def valid_json?
    @json_message = JSON.parse(message)
    return true
  rescue
    false
  end

  # @return[Hash,String] The parsed JSON message or a string
  def analyzed_message
    if valid_json?
      @json_message
    else
      message
    end
  end

  # @return[String] The name of the repository
  def repository_name
    analyzed_message['repository']['name']
  rescue
    false
  end

  # @return[String] The branch of the repository
  def repository_branch
    analyzed_message['ref'].split('/')[2]
  rescue
    false
  end

  # @return[Array] The GitHub_SNS_Service_Hooks section of the configuration.
  def github_commands
    [config['GitHub_SNS_Service_Hooks'][repository_name][repository_branch]]
  rescue
    puts 'No valid GitHub SNS Service Hooks found in the configuration'
    []
  end

  # @return[Array] The SNS_Direct_Commands section of the configuration.
  def direct_commands
    [config['SNS_Direct_Commands'][subject]]
  rescue
    puts 'No valid SNS_Direct_Commands found in the configuration'
    []
  end

  # Executes a shell command
  def execute_shell(command)
    exec_command = IO.popen(command)
    while (line = exec_command.gets); puts line; end
  rescue
    puts "Command failed: \"#{command}\""
  end
end # class Notification
