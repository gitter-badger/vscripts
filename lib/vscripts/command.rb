require 'vscripts/commands/tags2facts'

module VScripts
  # Main Command class
  class Command
    # Lists the available commands
    # @return [Array]
    def self.list
      VScripts::Commands.constants.select do |cls|
        VScripts::Commands.const_get(cls).is_a? Class
      end
    end
  end # class Command
end # module VScripts
