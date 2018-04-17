require 'test_helper'

class LabControllerTest < ActionDispatch::IntegrationTest
  test "should get input" do
    get lab_input_url
    assert_response :success
  end

  test "should get output" do
    get lab_output_url
    assert_response :success
  end

end
