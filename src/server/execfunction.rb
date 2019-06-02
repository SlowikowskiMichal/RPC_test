require 'timeout'
require 'securerandom'
require 'fileutils'
require 'open3'
include Open3

def ccrf(fileContent)
  begin
    RubyVM::InstructionSequence.compile(fileContent)
  rescue Exception => e
    puts "Compilation failed"
    return "Compulation failed",e.message, nil?
  end

  folderID = SecureRandom.uuid
  #FileUtils.mkdir_p "result/#{folderID}"

  File.open("result/#{folderID}.rb","w") do |element|
    element.puts(fileContent)
  end


  stdout_str, error_str, status = Open3.capture3('C:\\Ruby25-x64\\bin\\ruby.exe', "result/#{folderID}.rb")
  puts $?
  puts "STDOUT : #{stdout_str}"
  puts "ERR : #{error_str}"
  puts "STATUS : #{status}"
  return stdout_str, error_str, status
end