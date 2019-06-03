require 'test/unit'
require './src/client/clientConfig.rb'
class MyTest < Test::Unit::TestCase
  def setup
    @path_to_json = "./resources/serverConfig.json"
    @addr	= "192.168.8.111"
    @port =	"5555"
    @queue_name = "rpc-queue"
  end

  def teardown
    # Do nothing
  end

  test "should_return_server_address_as_local_host_by_default" do
    configuration_loader = ClientConfigurationLoader.new
    actual = configuration_loader.server_addr
    assert_equal("127.0.0.1",actual,"Incorrect default server address")
  end

  test "should_return_server_port_as_default_rqbbitmq_port_by_default" do
    configuration_loader = ClientConfigurationLoader.new
    actual = configuration_loader.server_port
    assert_equal("5762",actual,"Incorrect default server port")
  end

  test "should_return_server_queue_name_as_rpc-queue_by_default" do
    configuration_loader = ClientConfigurationLoader.new
    actual = configuration_loader.queue_name
    assert_equal("rpc-queue",actual,"Incorrect default queue name")
  end
  #@queue_name["server"]["queue_name"]
  test "should_parse_json_files_to_client_attributes" do
    configuration_loader = ClientConfigurationLoader.new
    configuration_loader.load_configuration(@path_to_json)
    actual_server = configuration_loader.server_addr
    actual_port = configuration_loader.server_port
    actual_queue = configuration_loader.queue_name
    assert_equal(@addr,actual_server,"Incorrect server address")
    assert_equal(@port,actual_port,"Incorrect server port")
    assert_equal(@queue_name,actual_queue,"Incorrect queue name")
  end
end