require 'test_helper'

class PayFileSemanticTest < MiniTest::Unit::TestCase
  
  attr_accessor :parser, :f

  def setup
    @parser = PayFileParser.new
    @f = parser.parse(pay_file.read)
    @transactions = f.batches.first.transactions
  end

  def assert_can_parse(string)
    assert parser.parse(string), "Failed on:\n#{string}\n Reason:\n#{@parser.failure_reason.inspect}\n"
  end

  def test_file_batches
    assert_equal 4, f.batches.length
  end

  def test_batch_transactions
    assert_equal  [7,4,2,0], f.batches.map{|batch| batch.transactions.length}
    assert_equal DeftPayments::Transaction, @transactions.first.class
  end

  def test_transaction_amounts
    assert_equal [1000, 8025, 43400, 2000, 5000, 10000, 5000], @transactions.map{|transaction| transaction.amount.cents}
  end

  def test_transaction_direction
    assert_equal "Payment", @transactions.first.type
    assert_equal "Refund", f.batches[2].transactions[1].type
  end

  def test_transaction_references
    assert_equal ["001048-301912812-180378", "001048-301912812-73002675", "001048-301912812-4628887", "001048-301912812-42114625"], f.batches[1].transactions.map{|transaction| transaction.reference}
  end

  def test_transaction_date
    assert_equal Time.new("2012-08-09 00:00:00"), f.batches[1].transactions.first.timestamp
  end

  def test_transaction_data
    assert_equal "2184-446301912804EVERYDAY HERO - AGENCY ACCOUNT     20120809           10.00CRDSCash Payment                            1537667", f.batches.first.transactions.first.data
  end

  def test_batch_reference
    assert_equal f.batches.first.reference, @transactions.first.batch_reference
  end

  def test_transaction_source
    assert_equal "Cash",   @transactions[0].source
    assert_equal "Cheque", @transactions[2].source
    assert_equal "BPay",   @transactions[3].source
    assert_equal "Credit Card", f.batches[1].transactions.first.source
  end

private
  def pay_file
    File.open(File.join(File.dirname(__FILE__),'fixtures', 'test.pay'), 'r')
  end
end
