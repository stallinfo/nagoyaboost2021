require "test_helper"

class ApisControllerTest < ActionDispatch::IntegrationTest
  test "should get salespoints" do
    get apis_salespoints_url
    assert_response :success
  end
end
