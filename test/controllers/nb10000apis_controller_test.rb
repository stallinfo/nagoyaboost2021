require "test_helper"

class Nb10000apisControllerTest < ActionDispatch::IntegrationTest
  test "should get mujin_all" do
    get nb10000apis_mujin_all_url
    assert_response :success
  end
end
