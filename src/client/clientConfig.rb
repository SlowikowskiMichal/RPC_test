#TODO
# implement simple client config loader
# config from json
# only connection config (host, port) [user, pasword optional]

require './src/configLoader.rb'


class ClientConfigurationLoader < ConfigurationLoader
  attr_accessor :json_content, :server_addr, :server_port, :queue_name

  def initialize
    super()
    @server_addr = "127.0.0.1"
    @server_port = "5762"
    @queue_name = "rpc-queue"
  end

  def load_configuration(pathFile)
    super(pathFile)
    unless @json_content.empty?
      @server_addr = @json_content["server"]["addr"]
      @server_port = @json_content["server"]["port"]
      @queue_name = @json_content["server"]["queue_name"]
    end
  end
end