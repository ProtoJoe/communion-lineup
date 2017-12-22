require 'test_helper'

class CommunionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get communion_index_url
    assert_response :success
  end

end
