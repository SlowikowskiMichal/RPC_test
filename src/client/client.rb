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
          temp = sendFileToServer(file)
          mutex.synchronize {@result.append temp}
        }
      end
      threads.each{|t| t.join}
    else
      answer = sendFileToServer(@fileName)
      @result = parseAnswer(answer,@fileName)
    end
  end

  def sendFileToServer(file)
    opener = FileOpener.new(file)
    flag, content = opener.openFile
    if flag
      answer = executeRPCCall(content)
      return parseAnswer(answer,file)
    else
      return "Can't open file #{file}"
    end
  end

  def executeRPCCall(content)
    connection = RPCClient.new('rpc_queue')
    answer = connection.call(content)
    connection.stop
    return answer
  end

  def parseAnswer(answer,file)
    return "Result #{file}:\n#{answer}"
  end

  def printResult
      puts @result
  end


  private :sendFileToServer, :executeRPCCall, :parseAnswer
end


if __FILE__ == $0

  client = ClientApp.new(ARGV)
  client.run
  client.printResult
end