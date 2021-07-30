require "test_helper"

class LandingsControllerTest < ActionDispatch::IntegrationTest
  test "should get Home" do
    get landings_Home_url
    assert_response :success
  end
end
