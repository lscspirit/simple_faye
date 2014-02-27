module SimpleFaye
  module Processor
    class MessageProcessor
      include Faye::Logging

      # Constructor
      def initialize(msg)
        @message = msg
      end

      # Execution
      def perform_action(action)
        action_sym = action.to_sym
        if self.respond_to? action_sym
          self.send action_sym
        else
          raise NoMethodError, "'#{action}' not found in #{self.class.name}"
        end
      end

      # Property Accessor
      def message
        @message
      end
    end
  end
end