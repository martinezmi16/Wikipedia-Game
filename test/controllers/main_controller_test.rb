require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
  end

  test "should get finished" do
    get :finished
    assert_response :success
  end

end
