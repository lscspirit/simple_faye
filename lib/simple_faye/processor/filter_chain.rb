require 'simple_faye/processor/filter'

module SimpleFaye
  module Processor
    class FilterChain < Array
      def run_filters(context, type, action)
        self.send(type == :before ? :each : :reverse_each) do |filter|
          filter.run(context) if filter.should_apply? type, action
        end
      end
    end
  end
end