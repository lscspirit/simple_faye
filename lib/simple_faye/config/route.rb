module SimpleFaye
  module Config
    class Route
      attr_reader :command, :processor, :action

      def initialize(ch_regex, command, processor, action)
        raise ArgumentError, 'Route\'s processor is missing' unless processor
        raise ArgumentError, 'Route\'s action is missing' unless action

        @command = command.to_s if command
        @processor = processor.to_s
        @action = action.to_sym

        # if the regex is a string, then turns it into a Regexp
        @regex = case
                   when ch_regex.is_a?(Regexp)
                     ch_regex
                   when ch_regex.is_a?(String)
                     Regexp.new("^#{Regexp.escape ch_regex}$")
                   else
                     raise ArgumentError, 'Invalid channel regex'
                 end
      end

      # Matches a channel name against the channel regex and command of this route
      def match(channel, command)
        @regex.match(channel) && (command.nil? || command == @command)
      end
    end
  end
end