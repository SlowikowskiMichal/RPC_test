if RUBY_VERSION.to_f < 2.0
  $stderr.puts "Ruby version 2.0 or higher required!"
  exit 1
end
require './src/client/rpc_client.rb'
require './src/client/file_manager.rb'
require './src/client/client_config.rb'

class ClientApp
  @result
  @file_name
  @configuration

  def initialize(argv = "")
    load_configuration
    unless @configuration.json_content.empty?
      @result = []
      if argv.empty?
        puts 'Give me a path to a file/files.'
        @file_name = gets.chomp
      else
        @file_name = argv
      end
    end
  end

  def run
    if @file_name.respond_to?('each')
      threads = []
      mutex = Mutex.new
      @file_name.each do |file|
        threads << Thread.new{
          temp = send_file_to_server(file)
          mutex.synchronize {@result.append temp}
        }
      end
      threads.each{|t| t.join}
    else
      answer = send_file_to_server(@file_name)
      @result = parse_answer(answer, @file_name)
    end
  end

  def send_file_to_server(file)
    opener = FileOpener.new(file)
    flag, content = opener.open_file
    if flag
      answer = execute_rpc_call(content)
      return parse_answer(answer, file)
    else
      return "Can't open file #{file}"
    end
  end

  def execute_rpc_call(content)
    connection = RPCClient.new(@configuration.server_queue_name,@configuration.server_addr,@configuration.server_port)
    answer = connection.call(content)
    connection.stop
    return answer
  end

  def parse_answer(answer, file)
    return "Result #{file}:\n#{answer}"
  end

  def print_result
      puts @result
  end

  def load_configuration
    @configuration = ClientConfigurationLoader.new
    @configuration.load_configuration("./src/client/clientConfig.json")
  end


  private :send_file_to_server, :execute_rpc_call, :parse_answer
end


if __FILE__ == $0

  client = ClientApp.new(ARGV)
  client.run
  client.print_result
end