# encoding: UTF-8
require 'vscripts/api'

module VScripts
  # Commands module
  module Commands
    # API Command Class
    class Api
      # Shows help
      USAGE = <<-EOS

This command starts the API server.

  USAGE:
  $ vscripts api

  OPTIONS:
      EOS

      # @return [Array] the command specific arguments
      attr_reader :arguments
      # @return [String] the command name
      attr_reader :command
      # @return [Array] the command specific arguments.
      attr_reader :command_options

      # Loads the Api command
      # @param argv [Array] the command specific arguments
      def initialize(args = [])
        parse(args)
      end

      # Specifies command line options
      def parser
        Trollop::Parser.new do
          banner USAGE
          opt :help, 'Show this menu', short: '-h'
          stop_on_unknown
        end
      end

      # @return [Hash] the command line arguments
      def parse(args)
        Trollop.with_standard_exception_handling parser do
          @arguments = parser.parse args
          fail Trollop::HelpNeeded if args.empty? || !parse_command(args)
        end
      end

      # Ensures command is available
      # @return [String] the command name
      # @return [Array] the command specific arguments
      def parse_command(args)
        command = args.shift
        return unless command
        available = %w(start)
        abort "Error: unknown subcommand '#{command}'\nTry --help." \
          unless available.include?(command)
        @command, @command_options = [command, args]
      end

      # Runs the API
      def execute
        VScripts::API.run!
      end
    end # class API
  end # module Commands
end # module VScripts
