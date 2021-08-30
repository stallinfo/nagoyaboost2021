require "test_helper"

class SalesPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_point = sales_points(:one)
  end

  test "should get index" do
    get sales_points_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_point_url
    assert_response :success
  end

  test "should create sales_point" do
    assert_difference('SalesPoint.count') do
      post sales_points_url, params: { sales_point: { capacity: @sales_point.capacity, description: @sales_point.description, lat: @sales_point.lat, lon: @sales_point.lon, name: @sales_point.name, status: @sales_point.status, user_id: @sales_point.user_id } }
    end

    assert_redirected_to sales_point_url(SalesPoint.last)
  end

  test "should show sales_point" do
    get sales_point_url(@sales_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_point_url(@sales_point)
    assert_response :success
  end

  test "should update sales_point" do
    patch sales_point_url(@sales_point), params: { sales_point: { capacity: @sales_point.capacity, description: @sales_point.description, lat: @sales_point.lat, lon: @sales_point.lon, name: @sales_point.name, status: @sales_point.status, user_id: @sales_point.user_id } }
    assert_redirected_to sales_point_url(@sales_point)
  end

  test "should destroy sales_point" do
    assert_difference('SalesPoint.count', -1) do
      delete sales_point_url(@sales_point)
    end

    assert_redirected_to sales_points_url
  end
end
