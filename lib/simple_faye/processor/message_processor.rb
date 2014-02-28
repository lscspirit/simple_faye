require 'simple_faye/processor/filter_chain'

module SimpleFaye
  module Processor
    class MessageProcessor
      include Faye::Logging
      include SimpleFaye::Bayeux::Error

      # Properties
      class << self; attr_accessor :filter_chain end
      attr_reader :message

      # Constructor
      def initialize(msg)
        @message = msg
      end

      def self.inherited base
        base.filter_chain = FilterChain.new
      end

      # Execution
      def perform_action(action)
        action_sym = action.to_sym
        if self.respond_to? action_sym
          execute_with_filters(action_sym) { self.send action_sym }
        else
          raise NoMethodError, "'#{action}' not found in #{self.class.name}"
        end
      end

      private

      #
      # Filter Logic
      #
      def self.before_action(filter_method, options = {})
        self.filter_chain << BeforeFilter.new(filter_method, options)
      end

      def self.after_action(filter_method, options = {})
        self.filter_chain << AfterFilter.new(filter_method, options)
      end

      def execute_with_filters(action)
        if self.class.filter_chain.run_filters self, :before, action
          # only continues if before filters are successfully executed
          yield if block_given?   # executes main action

          # executes after filters, no filter will run if the message['error'] field is already set
          self.class.filter_chain.run_filters self, :after, action
        end
      end
    end
  end
end