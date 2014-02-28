class TestProcessor < ::SimpleFaye::Processor::MessageProcessor
  before_action :before_hook
  after_action  :after_hook

  def test
    debug "incoming text: #{message['data']['text']}"
  end

  private

  def before_hook
    debug "BEFOREEEEEEEEE #{message['data']['text']}"
  end

  def after_hook
    debug "AFTERRRRRRRRRR #{message['data']['text']}"
  end
end