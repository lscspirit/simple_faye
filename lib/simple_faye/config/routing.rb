module SimpleFaye
  module Config
    class Routing
      attr_reader :mappings

      def initialize
        @mappings = []
      end

      # Maps a regular expression, representing channel name(s), to a specific processor AND action
      def map(channel_regex, options = {})
        @mappings << Route.new(channel_regex, options[:type], options[:command], options[:processor], options[:action])
      end

      #
      # Attribute Accessors
      #
      def mappings
        @mappings
      end
    end
  end
end