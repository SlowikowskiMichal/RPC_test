require 'json'

class ConfigurationLoader
  attr_accessor :json_content

  def initialize
    @json_content = ""
  end

  def load_configuration(path)
    if File.readable? path
      file = File.read(path)
      @json_content = JSON.parse(file)
    else
      @json_content = ""
    end
  end
end
