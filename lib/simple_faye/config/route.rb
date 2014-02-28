module SimpleFaye
  module Config
    class Route
      attr_reader :processor, :action

      def initialize(regex, processor, action)
        @processor = processor.to_s
        @action = action.to_sym

        # if the regex is a string, then turns it into a Regexp
        @regex = case
                   when regex.is_a?(Regexp)
                     regex
                   when regex.is_a?(String)
                     Regexp.new("^#{Regexp.escape regex}$")
                   else
                     raise ArgumentError, 'Invalid channel regex'
                 end
      end

      # Matches a channel name against the channel regex of this route
      def match(channel)
        @regex.match(channel)
      end
    end
  end
end