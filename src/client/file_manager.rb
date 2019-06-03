class FileManager
  attr_accessor :file_path

  def initialize(file_path = "")
    @file_path = file_path
  end

  def set_file_path(file_path)
    @file_path = file_path
  end

  def open_file
    if validate_file_path(@file_path)
      file = File.open(@file_path)
      return true,file.read
    else
      return false,"I can't read that file\n#{@file_path}"
    end
  end

  def validate_file_path(file_path=@file_path)
    if File.readable? file_path
      return true
    else
      return false
    end
  end
end