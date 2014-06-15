# encoding: UTF-8
require 'vscripts/commands'
require 'vscripts/command_line'
require 'vscripts/config'

# Main VScripts module
module VScripts
  # Reads the command line arguments
  def self.cli
    @cli ||= CommandLine.new # Parses command line
  end

  # Reads the configuration files
  def self.config
    @config ||= VScripts::Config.new(cli.global.config) # Parses configuration
  end

  # Reads the arguments and runs the given command
  def self.run
    VScripts::AWS.configure
    VScripts::Commands.const_get(cli.command).new(cli.command_options).execute
  end
end # module VScripts
