module SimpleFaye
  module Extension
    class Router
      include Faye::Logging
      include SimpleFaye::Bayeux::Error

      #
      # Constructor
      #
      def initialize
        @routing_map = SimpleFaye::Config::Routing.new
      end

      #
      # Faye Adapter Hook (incoming / outgoing)
      #
      def incoming(message, callback)
        begin
          route_and_perform message
        rescue => ex
          # in case of runtime error, log the stack trace and return an '_unknown_error' error to the client
          fatal ex.message + "\n  " + ex.backtrace.join("\n  ")
          message['error'] = bayuex_error :server_error, 'Unknown error', 'simple_faye'
        end

        callback.call message
      end

      #
      # Configuration Methods
      #
      def map_channel
        yield @routing_map if block_given?
      end

      private

      # Dispatches the incoming message to the appropriate MessageProcessor
      # and perform the designated action
      def route_and_perform(message)
        channel = message['channel']
        # find matching route unless it is a Faye meta message
        unless channel.match(/\/meta\/.+/)
          command = message['data']['__command']
          matched = match_route channel, command

          if matched
            # if there is a matching route then perform the designated action
            processor = instantiate_processor matched.processor, message
            processor.perform_action matched.action
          else
            # if there is no matching route, so return a invalid channel error
            message['error'] = bayeux_error :channel_unknown, 'No route found for channel and command', 'simple_faye', "#{channel}#{command ? "##{command}" : ''}"
          end
        end
      end

      # Finds a matching route for the specified channel and command
      # Returns a Route object if found; otherwise nil is returned
      def match_route(channel, command)
        # go through the list of channel mappings to find a matching route
        @routing_map.mappings.each do |route|
          return route if route.match(channel, command)
        end

        nil
      end

      # Creates an instance of the specified processor
      # Execeptions are raised if the processor is not found or it is not a subclass of MessageProcessor
      def instantiate_processor(processor, message)
        # check if the processor is a constant
        klass = processor.is_a?(Class) ? processor : Kernel.const_get(processor)
        # check if klass is a subclass of MessageProcessor
        raise "#{processor} is not a SimpleFaye::Processor::MessageProcessor" unless klass <= SimpleFaye::Processor::MessageProcessor

        # creates an instance of klass (MessageProcessor)
        klass.new message
      end
    end
  end
end