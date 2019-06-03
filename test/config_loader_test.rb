require 'test/unit'
require '../src/config_loader.rb'

class ConfigLoaderTest < Test::Unit::TestCase
  def setup
    @path_to_json = "..resources/exampleConfig.json"
  end

  def teardown
  end

  test "should_load_json_with_valid_path" do
    configuration_loader = ConfigurationLoader.new
    configuration_loader.load_configuration(@path_to_json)
    actual = configuration_loader.json_content
    assert(!actual.empty?,"Couldn't load JSON file from #{@path_to_json}")
  end

  test "should_not_load_json_from_incorrect_path" do
    configuration_loader = ConfigurationLoader.new
    configuration_loader.load_configuration("incorrect")
    actual = configuration_loader.json_content
    assert(actual.empty?,"JSON content should be empty #{@path_to_json}")
  end

  test "should__JSON_content_be_empty_on_creation" do
    configuration_loader = ConfigurationLoader.new
    actual = configuration_loader.json_content
    assert(actual.empty?,"JSON content should be empty on creation")
  end
end