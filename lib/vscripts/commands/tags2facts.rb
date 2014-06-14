# encoding: UTF-8
require 'vscripts/aws'
require 'vscripts/util'

module VScripts
  # Commands module
  module Commands
    # Tags2Facts Class
    class Tags2facts
      include VScripts::AWS
      include VScripts::Util

      # Shows help
      USAGE = <<-EOS

This command can only be run on an AWS EC2 instance. It looks for all tags
associated with it and dumps them in a JSON file. By default this file is
`/etc/facter/facts.d/ec2_tags.json`. It can be overridden with the
***`--file`*** argument.

The `Name` and `Domain` tags are excluded by default because this command is
intended to add Facter facts and these 2 already exist in Facter. This
behaviour can be overridden by adding `[-a|--all]` command line option.

  USAGE:
    vscripts tags2facts [options]

  OPTIONS:
      EOS

      # @return [Array] the command specific arguments
      attr_reader :arguments

      # Loads the Tags2Facts class
      # @param argv [Array] the command specific arguments
      def initialize(args = [])
        parse(args)
      end

      # Specifies command line options
      # This method smells of :reek:TooManyStatements but ignores them
      def parser
        Trollop::Parser.new do
          banner USAGE
          opt :file, 'The file that will store the tags',
              type: :string, default: '/etc/facter/facts.d/ec2_tags.json'
          opt :all, 'Collect all tags'
          opt :help, 'Show this menu', short: '-h'
          stop_on_unknown
        end
      end

      # @return [Hash] the command line arguments
      def parse(args)
        Trollop.with_standard_exception_handling parser do
          @arguments = parser.parse args
        end
      end

      # @return [Array] the tags to exclude
      def exclude_list
        arguments.all ? [] : %w(Name Domain)
      end

      # @return [JSON] the formatted JSON string
      def tags_json
        filtered = tags_without(exclude_list)
        if filtered.empty?
          abort 'No tags were found!'
        else
          JSON.pretty_generate(filtered)
        end
      end

      # Writes the formatted JSON to the file
      def execute
        file = arguments.file
        puts "Writing tags to \"#{file}\""
        ensure_file_content(file, tags_json)
        puts 'Done.'
      end
    end # class Tags2facts
  end # module Commands
end # module VScripts
