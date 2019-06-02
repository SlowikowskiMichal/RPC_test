
#Opens file from path with validation

class FileOpener
  @filePath

  def initialize(filePath = "")
    @filePath = filePath
  end

  def setFilePath(filePath)
    @filePath = filePath
  end

  def openFile

    if validateFilePath(@filePath)
      file = File.open(@filePath)
      return true,file.read
    else
      return false,"I can't read that file\n#{@filePath}"
    end
  end

  def validateFilePath(filePath)
    if File.readable? filePath
      return true
    else
      return false
    end
  end
end