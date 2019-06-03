#TODO
# Implement simple server config loader from json
# path to result folder
# path to ruby.exe
# connection variables

require './src/configLoader.rb'

class ServerConfigurationLoader < ConfigurationLoader
  attr_accessor :json_content, :server_addr, :server_port, :queue_name, :result_folder_path, :ruby_path

  def initialize
    super()
    @server_addr = "127.0.0.1"
    @server_port = "5762"
    @queue_name = "rpc-queue"
    @result_folder_path = "result"
    @ruby_path = 'C:\Ruby25-x64\bin\ruby.exe'
  end

  def load_configuration(pathFile)
    super(pathFile)
    unless @json_content.empty?
      @server_addr = @json_content["server"]["addr"] unless @json_content["server"]["addr"].nil?
      @server_port = @json_content["server"]["port"] unless @json_content["server"]["port"].nil?
      @queue_name = @json_content["server"]["queue_name"] unless @json_content["server"]["port"].nil?
      @result_folder_path = @json_content["result_folder_path"] unless @json_content["result_folder_path"].nil?
      @ruby_path = @json_content["ruby_path"] unless @json_content["result_folder_path"].nil?
    end
  end
end