require 'test/unit'
require './src/server/serverConfig.rb'
class MyTest < Test::Unit::TestCase
  def setup
    @path_to_json = "./resources/serverConfig.json"
    @addr = "192.168.8.111"
    @port = "5555"
    @queue_name = "rpc-queue"
    @result_folder_path = "new_result"
    @ruby_path = 'C:\example\ruby_folder'
  end

  def teardown
    # Do nothing
  end

  test "should_return_address_as_local_host_by_default" do
    configuration_loader = ServerConfigurationLoader.new
    actual = configuration_loader.server_addr
    assert_equal("127.0.0.1",actual,"Incorrect default server address")
  end

  test "should_return_port_as_default_rqbbitmq_port_by_default" do
    configuration_loader = ServerConfigurationLoader.new
    actual = configuration_loader.server_port
    assert_equal("5762",actual,"Incorrect default server port")
  end

  test "should_return_queue_name_as_rpc-queue_by_default" do
    configuration_loader = ServerConfigurationLoader.new
    actual = configuration_loader.queue_name
    assert_equal("rpc-queue",actual,"Incorrect default queue name")
  end

  test "should_return_result_as_result_folder_by_default" do
    configuration_loader = ServerConfigurationLoader.new
    actual = configuration_loader.result_folder_path
    assert_equal("result",actual,"Incorrect default result path")
  end

  test "should_return_default_ruby.exe_installation_path" do
    configuration_loader = ServerConfigurationLoader.new
    actual = configuration_loader.ruby_path
    assert_equal('C:\Ruby25-x64\bin\ruby.exe',actual,"Incorrect default ruby location")
  end

  test "should_parse_json_files_to_server_attributes" do
    configuration_loader = ServerConfigurationLoader.new
    configuration_loader.load_configuration(@path_to_json)

    actual_server = configuration_loader.server_addr
    actual_port = configuration_loader.server_port
    actual_queue = configuration_loader.queue_name
    actual_result_folder_path = configuration_loader.result_folder_path
    actual_ruby_path = configuration_loader.ruby_path

    assert_equal(@addr,actual_server,"Incorrect server address")
    assert_equal(@port,actual_port,"Incorrect server port")
    assert_equal(@queue_name,actual_queue,"Incorrect queue name")
    assert_equal(@result_folder_path,actual_result_folder_path,"Incorrect result path")
    assert_equal(@ruby_path,actual_ruby_path,"Incorrect ruby location")
  end
end