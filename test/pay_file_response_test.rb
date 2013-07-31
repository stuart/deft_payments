require 'test_helper'

class PayFileResponseTest < MiniTest::Unit::TestCase
  def test_success_when_code_is_200
    response = MiniTest::Mock.new
    response.expect :code, "200"
    assert DeftPayments::PayFileResponse.new(response).success?
  end

  def test_failure_when_code_is_not_200
    response = MiniTest::Mock.new
    response.expect :code, "404"
    refute DeftPayments::PayFileResponse.new(response).success?
  end

  def test_transactions_comes_from_parsing_the_response_body
    response = MiniTest::Mock.new
    file = File.open File.join(File.dirname(__FILE__),'fixtures/test.pay'), 'r'
    response.expect :body, File.read(file)
    assert_equal 13, DeftPayments::PayFileResponse.new(response).transactions.count
  end

  def test_response_is_valid_when_file_is_parsed
    response = MiniTest::Mock.new
    file = File.open File.join(File.dirname(__FILE__),'fixtures/test.pay'), 'r'
    response.expect :body, File.read(file)
    assert DeftPayments::PayFileResponse.new(response).valid?
  end

  def test_response_is_invalid_when_pay_file_cannot_be_parsed
    response = MiniTest::Mock.new
    response.expect :body, "INVALID DATA"
    refute DeftPayments::PayFileResponse.new(response).valid?
  end
end