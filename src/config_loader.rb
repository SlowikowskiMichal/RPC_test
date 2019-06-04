require 'json'

# Loads configuration based on path to JSON format file
class ConfigurationLoader
  attr_accessor :json_content

  # Initialize empty JSON
  def initialize
    @json_content = ""
  end

  # Loads configuration based on path to JSON format file
  # @param [String] path
  # @return [String]
  def load_configuration(path)
    if File.readable? path
      file = File.read(path)
      @json_content = JSON.parse(file)
    else
      @json_content = ""
    end
  end
end
