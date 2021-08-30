require "application_system_test_case"

class SalesPointsTest < ApplicationSystemTestCase
  setup do
    @sales_point = sales_points(:one)
  end

  test "visiting the index" do
    visit sales_points_url
    assert_selector "h1", text: "Sales Points"
  end

  test "creating a Sales point" do
    visit sales_points_url
    click_on "New Sales Point"

    fill_in "Capacity", with: @sales_point.capacity
    fill_in "Description", with: @sales_point.description
    fill_in "Lat", with: @sales_point.lat
    fill_in "Lon", with: @sales_point.lon
    fill_in "Name", with: @sales_point.name
    fill_in "Status", with: @sales_point.status
    fill_in "User", with: @sales_point.user_id
    click_on "Create Sales point"

    assert_text "Sales point was successfully created"
    click_on "Back"
  end

  test "updating a Sales point" do
    visit sales_points_url
    click_on "Edit", match: :first

    fill_in "Capacity", with: @sales_point.capacity
    fill_in "Description", with: @sales_point.description
    fill_in "Lat", with: @sales_point.lat
    fill_in "Lon", with: @sales_point.lon
    fill_in "Name", with: @sales_point.name
    fill_in "Status", with: @sales_point.status
    fill_in "User", with: @sales_point.user_id
    click_on "Update Sales point"

    assert_text "Sales point was successfully updated"
    click_on "Back"
  end

  test "destroying a Sales point" do
    visit sales_points_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sales point was successfully destroyed"
  end
end
