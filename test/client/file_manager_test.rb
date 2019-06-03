require 'test/unit'
require '../../src/client/file_manager.rb'
class FileManagerTest < Test::Unit::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  test "should_return_true_on_validation_if_file_exists" do
    fm = FileManager.new
    fm.set_file_path("./test/client/file_manager_test.rb")
    actual = fm.validate_file_path
    assert(actual,"Filepath should pass validation")
  end

  test "should_return_false_on_validation_if_file_doesn't_exists" do
    fm = FileManager.new
    fm.set_file_path("")
    actual = fm.validate_file_path
    assert_false(actual,"Filepath should pass validation")
  end

  test "should_return_file_content_if_file_exists" do
    fm = FileManager.new
    fm.set_file_path("./test/client/file_manager_test.rb")
    flag,content = fm.open_file
    assert(flag,"Should be able to read from file")
    assert_false(content.empty?, "File should contain some content")
  end

  test "should_return_error_message_if_file_exists" do
    fm = FileManager.new
    fm.set_file_path("")
    flag,content = fm.open_file
    assert_false(flag,"Should not be able to read from file")
    assert_equal("I can't read that file\n",content, "File should contain some content")
  end
end