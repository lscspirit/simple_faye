module SimpleFaye
  module Config
    class Routing
      attr_reader :mappings

      def initialize
        @mappings = []
      end

      # Maps a regular expression, representing channel name(s), to a specific processor AND action
      def channel(*args)
        options = extract_options! args
        options[:channel] = args.shift unless args.empty?

        @__scope_options = process_options options, :valid => [:channel, :processor], :require => [:channel]
        yield if block_given?
        @__scope_options = nil
      end

      def publish(*args)
        options = extract_options! args
        options[:channel] = args.shift unless args.empty?

        # infers the :action from :command if :action is not specified
        options[:action] ||= options[:command].to_sym if options[:command]

        options = process_options options, :valid => [:channel, :command, :processor, :action], :require => [:channel, :processor, :action]

        map options[:channel], :publish, options[:command], options[:processor], options[:action]
      end

      def subscribe(*args)
        options = extract_options! args
        options[:channel] = args.shift unless args.empty?

        options = process_options options, :valid => [:channel, :processor, :action], :require => [:channel, :processor, :action]

        map options[:channel], :subscribe, nil, options[:processor], options[:action]
      end

      def unsubscribe(*args)
        options = extract_options! args
        options[:channel] = args.shift unless args.empty?

        options = process_options options, :valid => [:channel, :processor, :action], :require => [:channel, :processor, :action]

        map options[:channel], :unsubscribe, nil, options[:processor], options[:action]
      end

      #
      # Attribute Accessors
      #
      def mappings
        @mappings
      end

      private

      def map(channel_regex, type, command, processor, action)
        @mappings << Route.new(channel_regex, type, command, processor, action)
      end

      def extract_options!(args)
        args.last.is_a?(::Hash) ? args.pop : {}
      end

      def process_options(options, spec = {})
        # merge options with those that is already in @__scope_options
        merged_opts = (@__scope_options || {}).merge(options)

        # checks if all keys are valid
        merged_opts.each_key do |k|
          raise ArgumentError, "#{k} is not a valid option" unless (spec[:valid] || []).include?(k)
        end

        # checks if all required keys are present
        (spec[:require] || []).each do |k|
          raise ArgumentError, "#{k} cannot be blank or missing" unless merged_opts.key?(k)
        end

        merged_opts
      end
    end
  end
end