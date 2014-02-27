class TestProcessor < ::SimpleFaye::Processor::MessageProcessor
  def test
    debug "incoming text: #{message['data']['text']}"
  end
end