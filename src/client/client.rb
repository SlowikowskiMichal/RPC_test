if RUBY_VERSION.to_f < 2.0
  $stderr.puts "Ruby version 2.0 or higher required!"
  exit 1
end
require 'timeout'
require 'securerandom'
require 'fileutils'
require './src/client/rpcClient.rb'
require 'open3'
include Open3


def openFile(filePath)
  result = nil?
  if File.readable? filePath

    puts 'I can read that file'
    file = File.open(filePath)
    content = file.read
    client = RPCClient.new('rpc_queue')
    result = client.call(content)
    client.stop
  else
    result = "I can't read that file\n#{filePath}"
  end
  return result
end

if __FILE__ == $0
  result = []

  if ARGV.empty?
    puts 'Give me a path to a file/files.'
    fileName = gets.chomp
  else
    fileName = ARGV
  end
  if fileName.respond_to?('each')
    fileName.each do |file|
      result.append "Result: #{file}\n#{openFile(file)}"
    end
  else
    result = "Result: #{fileName}\n#{openFile(fileName)}"
  end
  puts result
end