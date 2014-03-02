module SimpleFaye
  module Config
    class Route
      ROUTE_TYPES = [:publish, :subscribe, :unsubscribe]

      attr_reader :command, :processor, :action

      def initialize(ch_regex, type, command, processor, action)
        # default values
        type ||= :publish

        # argument checks
        raise ArgumentError, 'Route\'s processor is missing' unless processor
        raise ArgumentError, 'Route\'s action is missing' unless action
        raise ArgumentError, "#{type} is not a valid route type" unless ROUTE_TYPES.include?(type)
        raise ArgumentError, '\'command\' option is not allowed when the route type is not :publish' if command && type != :publish

        @type = type
        @command = command.to_s if command
        @processor = processor
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
      def match(type, channel, command = nil)
        @type == type && @regex.match(channel) && (command.nil? || command == @command)
      end
    end
  end
end