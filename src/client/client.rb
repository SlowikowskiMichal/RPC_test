if RUBY_VERSION.to_f < 2.0
  $stderr.puts "Ruby version 2.0 or higher required!"
  exit 1
end
require './src/client/rpcClient.rb'
require './src/client/fileOpener.rb'

class ClientApp
  @result
  @fileName

  def initialize(argv = "")
    @result = []
    if argv.empty?
      puts 'Give me a path to a file/files.'
      @fileName = gets.chomp
    else
      @fileName = argv
    end
  end

  def run
    if @fileName.respond_to?('each')
      threads = []
      mutex = Mutex.new
      @fileName.each do |file|
        threads << Thread.new{
          temp = send_file_to_server(file)
          mutex.synchronize {@result.append temp}
        }
      end
      threads.each{|t| t.join}
    else
      answer = send_file_to_server(@fileName)
      @result = parse_answer(answer, @fileName)
    end
  end

  def send_file_to_server(file)
    opener = FileOpener.new(file)
    flag, content = opener.openFile
    if flag
      answer = execute_rpc_call(content)
      return parse_answer(answer, file)
    else
      return "Can't open file #{file}"
    end
  end

  def execute_rpc_call(content)
    connection = RPCClient.new('rpc_queue')
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


  private :send_file_to_server, :execute_rpc_call, :parse_answer
end


if __FILE__ == $0

  client = ClientApp.new(ARGV)
  client.run
  client.print_result
end