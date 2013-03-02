require 'test_helper'

class PayFileSyntaxTest < MiniTest::Unit::TestCase

  attr_accessor :parser

  def setup
    @parser = PayFileParser.new
  end

  def assert_can_parse(string)
    assert !parser.parse(string).nil?, "Failed on:\n#{string}\n Reason:\n#{@parser.failure_reason.inspect}\n"
  end

  def assert_cannot_parse(string)
    p = parser.parse(string)
    assert p.nil?, "Failed on:\n#{string}\n Reason:\nThis should not be correctly parsed, but was.\nParser Output:\n#{p.inspect}"
  end

  def test_bpay_transaction
    assert_can_parse wrap_transaction("2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20120809           50.00CRBPBPay Payment                            81663248")
  end

  def test_another_bpay_transaction
    assert_can_parse wrap_transaction("2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20101130          100.00CRBPBPay Payment                            3245227")
  end

  def test_cheque_transaction
    assert_can_parse wrap_transaction("2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20101130          500.00CRDQCheque Payment                          73341273")
  end 

  def test_cash_transaction
    assert_can_parse wrap_transaction("2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20101130           15.00CRDSCash Payment                            18378")
  end

  def test_internet_payment
    assert_can_parse wrap_transaction("2184-446301912812EVERYDAY HERO - EVENTS ACCOUNT     20120809           20.00CRICInternet Credit Card Payment            840141")
  end

  def test_bpay_error_correction
    assert_can_parse wrap_transaction("2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20110131         2500.00DRBCBPay Error Correction                   61376162")
  end

  # # This runs the parser against all historical DEFT data.
  # def test_multiple_files
  #   failed = []
  #   Dir.glob(File.join(File.dirname(__FILE__),'fixtures/*.pay')).each do |pay_file_name|
  #     pay_file = File.open(pay_file_name, 'r')
  #     print pay_file_name
  #     unless parser.parse(pay_file.read)
  #       failed << pay_file_name
  #       puts " - FAILED"
  #     else
  #       puts " - OK"
  #     end
  #     pay_file.close
  #   end
  #   assert_equal [], failed
  # end

  def test_single_file
    file = File.open File.join(File.dirname(__FILE__),'fixtures/20110720.pay'), 'r'
    assert_can_parse file.read
  end

private
  def wrap_transaction trans
    [file_header, batch_header, trans, batch_trailer, file_trailer, ''].join("\r\n")
  end

  def file_header
    "056338249EVERYDAY HERO PTY LT               MACQUARIE BANK      2010120120101201DEFT PAYMENTS"
  end

  def file_trailer
    "956338249EVERYDAY HERO PTY LT                    0   565            0.00        46938.25"
  end

  def batch_header
    "1184-446301912804EVERYDAY HERO - AGENCY ACCOUNT"
  end

  def batch_trailer
    "7184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20120810        40113.25CRSP001047     0   422            0.00        40113.25"
  end
end


