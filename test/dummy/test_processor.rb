class TestProcessor < ::SimpleFaye::Processor::MessageProcessor
  before_action :before_hook, :only => :hh
  before_action :before_hook_2
  after_action  :after_hook
  after_action  :after_hook_2

  def test
    debug "incoming text: #{message['data']['text']}"
    #message['error'] = 'has error'
  end

  def subscribe
    debug "subscribing"
  end

  private

  def before_hook
    debug "BEFOREEEEEEEEE #{message['data']['text']}"
  end

  def before_hook_2
    debug "BEFORE 222222"
  end

  def after_hook
    debug "AFTERRRRRRRRRR"
  end

  def after_hook_2
    debug "AFTER 2222"
  end
end