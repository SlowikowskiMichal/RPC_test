require 'timeout'
require 'securerandom'
require 'fileutils'
require 'open3'
include Open3

class ProgramExecutor

  def create_file(file_content,result_path)
    program_id = SecureRandom.uuid
    unless File.directory? result_path
      FileUtils.mkdir_p result_path
    end

    File.open("#{result_path}/#{program_id}.rb", "w") do |element|
      element.puts(file_content)
    end

    return "#{result_path}/#{program_id}.rb"
  end

  def execute(file_content,ruby_path,result_path)

    begin
      path = create_file(file_content,result_path)
    rescue Exception => e
        return "File Creation Error\nContact Server Administrator","#{e.message}",nil?
    end

    flag, err = is_file_compilable(file_content)

    if flag
      @stdout_str, @error_str, @status = Open3.capture3(ruby_path, path)
      puts "STDOUT : #{@stdout_str}"
      puts "ERR : #{@error_str}"
      puts "STATUS : #{@status}"
      return @stdout_str, @error_str, @status
    end

    return "Can't compile file", err, nil?
  end

  def is_file_compilable(file_content)
    begin
      RubyVM::InstructionSequence.compile(file_content)
    rescue Exception => e
      return false,e.message
    end
    return true,nil?
  end

  private :is_file_compilable, :create_file
end