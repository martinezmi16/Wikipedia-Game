require 'test_helper'

class GameplayControllerTest < ActionController::TestCase
  test "should get countdown" do
    get :countdown
    assert_response :success
  end

  test "should get wikigame" do
    get :wikigame
    assert_response :success
  end

end
