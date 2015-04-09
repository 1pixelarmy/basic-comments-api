require 'test_helper'

class PlugTypesControllerTest < ActionController::TestCase
  setup do
    @plug_type = plug_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plug_types)
  end

  test "should create plug_type" do
    assert_difference('PlugType.count') do
      post :create, plug_type: { name: @plug_type.name, power: @plug_type.power }
    end

    assert_response 201
  end

  test "should show plug_type" do
    get :show, id: @plug_type
    assert_response :success
  end

  test "should update plug_type" do
    put :update, id: @plug_type, plug_type: { name: @plug_type.name, power: @plug_type.power }
    assert_response 204
  end

  test "should destroy plug_type" do
    assert_difference('PlugType.count', -1) do
      delete :destroy, id: @plug_type
    end

    assert_response 204
  end
end
