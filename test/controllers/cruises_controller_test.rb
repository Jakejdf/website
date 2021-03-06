require 'test_helper'

class CruisesControllerTest < ActionController::TestCase
  setup do
    @cruise = cruises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cruises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cruise" do
    assert_difference('Cruise.count') do
      post :create, cruise: { content: @cruise.content, end_at: @cruise.end_at, slug: @cruise.slug, start_at: @cruise.start_at, title: @cruise.title, venue_id: @cruise.venue_id }
    end

    assert_redirected_to cruise_path(assigns(:cruise))
  end

  test "should show cruise" do
    get :show, id: @cruise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cruise
    assert_response :success
  end

  test "should update cruise" do
    patch :update, id: @cruise, cruise: { content: @cruise.content, end_at: @cruise.end_at, slug: @cruise.slug, start_at: @cruise.start_at, title: @cruise.title, venue_id: @cruise.venue_id }
    assert_redirected_to cruise_path(assigns(:cruise))
  end

  test "should destroy cruise" do
    assert_difference('Cruise.count', -1) do
      delete :destroy, id: @cruise
    end

    assert_redirected_to cruises_path
  end
end
