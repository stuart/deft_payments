require 'test_helper'

class PayFileRequestTest < MiniTest::Unit::TestCase
  def setup
    @pay_file_request = DeftPayments::PayFileRequest.new(username: "4545433", password: "password", customer_number: "12345", date: Time.new(2012,02,01))
  end

  def test_default_uri_is_correct
    uri = @pay_file_request.uri
    assert_equal "www.macquarie.com.au", uri.host
    assert_equal "/ab3directdownload/download", uri.path
    assert_equal 443, uri.port
    assert_equal "username=4545433&password=password&customerNumber=12345&fileType=P&fileDate=2012-02-01", uri.query
  end

  def test_post_makes_a_request_on_the_connection
    mock_http = MiniTest::Mock.new
    mock_http.expect :request, "Response", [Net::HTTP::Post]
    @pay_file_request.connection = mock_http
    assert_equal "Response", @pay_file_request.post
  end
end
