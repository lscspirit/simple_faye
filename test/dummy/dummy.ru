require 'faye'
require 'logger'
require 'thin'

require 'simple_faye'

require File.expand_path('../test_processor', __FILE__)

Faye.logger = Logger.new(STDOUT)
Faye.logger.level = Logger::DEBUG

Faye::WebSocket.load_adapter 'thin'

router = SimpleFaye::Extension::Router.new
router.map_channel do |r|
  r.channel '/test_channel', :processor => TestProcessor do
    r.publish :command => 'test', :action => :test
    r.subscribe :action => :subscribe
  end

  r.publish /^\/regex_channel(\d)$/, :processor => :TestProcessor, :action => :again
  r.publish '/invalid_processor', :processor => :InvalidProcessor, :action => :test
end

faye_server = Faye::RackAdapter.new :mount => '/simple_faye', :timeout => 25
faye_server.add_extension(router)

run faye_server
