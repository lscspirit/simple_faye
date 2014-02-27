module SimpleFaye
  module Config
    class Routing
      def initialize
        @mapping = []
      end

      # Maps a regular expression, representing channel name(s), to a specific processor AND action
      def map(channel_regex, processor, action)
        @mapping << Route.new(channel_regex, processor, action)
      end

      #
      # Attribute Accessors
      #
      def mappings
        @mapping
      end
    end
  end
end