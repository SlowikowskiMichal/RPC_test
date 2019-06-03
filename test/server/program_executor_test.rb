require 'test/unit'
require './src/server/program_executor.rb'
require 'mocha/test_unit'

class MyTest < Test::Unit::TestCase
  def setup
    @program = "1 + 1"
    @result_folder_path = "result"
    @ruby_path = 'C:\example\ruby_folder'
    @programID = "randomID"
    @iprogram = "1 + "
    @incorrect_result_folder = "results"
  end

  def teardown
    # Do nothing
  end

  test "should_correct_program_compile" do
    pe = ProgramExecutor.new
    flag,msg = pe.is_file_compilable(@program)
    assert(flag,"Program can't be compiled")
    assert(msg.empty?,"Message should be empty")
  end

  test "should_incorrect_program_return_error_on_compilation" do
    pe = ProgramExecutor.new
    flag,msg = pe.is_file_compilable(@iprogram)
    assert(!flag,"Program can be compiled")
    assert(!msg.empty?,"Message should be contain error description")
  end

  test "should_return_path_to_file_if_result_folder_exists" do
    pe = ProgramExecutor.new
    actual = pe.create_file(@program,@result_folder_path,@programID)
    assert_equal(@result_folder_path+"/"+@programID+".rb",actual,"Incorrect path to file")
    File.delete(actual) if File.exist?(actual)
  end

  test "should_return_path_to_file_if_result_folder_doesn't_exists" do
    pe = ProgramExecutor.new
    actual = pe.create_file(@program,@incorrect_result_folder,@programID)
    assert_equal(@incorrect_result_folder+"/"+@programID+".rb",actual,"Incorrect path to file")
    File.delete(actual) if File.exist?(actual)
    FileUtils.remove_dir(@incorrect_result_folder) if File.directory?(@incorrect_result_folder)
  end

  test "should_return_error_if_program_can't_be_compiled" do
    pe = ProgramExecutor.new
    stdout,error,status = pe.execute(@iprogram,@result_folder_path,@programID)
    assert_equal("Can't compile file",stdout,"Incorrect program output")
    assert(!error.empty?,"Incorrect error message")
    file = @incorrect_result_folder+"/"+@programID+".rb"
    File.delete(file) if File.exist?(file)
    FileUtils.remove_dir(@result_folder_path) if File.directory?(@incorrect_result_folder)
  end

  test "should_return_result_if_program_can_be_compiled" do
    pe = ProgramExecutor.new
    pe.expects(:run_software).returns(2,"","")
    stdout,error,status = pe.execute(@program,@result_folder_path,@programID)
    assert_equal(2,stdout,"Incorrect program output")
    assert(error.nil?,"Incorrect error message")
    file = @incorrect_result_folder+"/"+@programID+".rb"
    File.delete(file) if File.exist?(file)
    FileUtils.remove_dir(@result_folder_path) if File.directory?(@incorrect_result_folder)
  end
end