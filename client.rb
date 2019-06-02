if RUBY_VERSION.to_f < 2.0
  $stderr.puts "Ruby version 2.0 or higher required!"
  exit 1
end
require 'timeout'
require 'securerandom'
require 'fileutils'
require 'open3'
include Open3


def sendFile(filePath)
  result = nil?
  if File.readable? filePath
    puts 'I can read that file'
    file = File.open(filePath)
    content = file.read
    result = f(content)
  else
    result = 'I can\'t read that file'
  end
  return result
end


def f(fileContent)
  begin
    RubyVM::InstructionSequence.compile(fileContent)
  rescue Exception => e
    puts "Compilation failed"
    return e.message
  end

  folderID = SecureRandom.uuid
  FileUtils.mkdir_p folderID

  File.open("#{folderID}/program.rb","w") do |element|
    element.puts(fileContent)
  end


  stdout_str, error_str, status = Open3.capture3('C:\\Ruby25-x64\\bin\\ruby.exe', "#{folderID}/program.rb")
  puts $?
  puts "STDOUT : #{stdout_str}"
  puts "ERR : #{error_str}"
  puts "STATUS : #{status}"
  return stdout_str, error_str, status

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
    puts 'Multiple files.'
    fileName.each do |file|
      result.append sendFile(file)
    end
  else
    result = sendFile(fileName)
  end
end