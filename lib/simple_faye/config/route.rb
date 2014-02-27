module SimpleFaye
  module Config
    class Route
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

      #
      # Attribute Accessors
      #
      def processor
        @processor
      end

      def action
        @action
      end
    end
  end
end