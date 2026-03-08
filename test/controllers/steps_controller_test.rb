require "test_helper"

class StepsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @step = steps(:one)
  end

  test "should get index" do
    get steps_url, as: :json
    assert_response :success
  end

  test "should create step" do
    assert_difference("Step.count") do
      post steps_url, params: { step: { count: @step.count, device_id: @step.device_id, recorded_at: @step.recorded_at } }, as: :json
    end

    assert_response :created
  end

  test "should show step" do
    get step_url(@step), as: :json
    assert_response :success
  end

  test "should update step" do
    patch step_url(@step), params: { step: { count: @step.count, device_id: @step.device_id, recorded_at: @step.recorded_at } }, as: :json
    assert_response :success
  end

  test "should destroy step" do
    assert_difference("Step.count", -1) do
      delete step_url(@step), as: :json
    end

    assert_response :no_content
  end
end
