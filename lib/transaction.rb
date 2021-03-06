module DeftPayments
  class Transaction < Treetop::Runtime::SyntaxNode
    def amount
      amount_string.to_money("AUD")
    end

    def timestamp
      date.to_time
    end

    def status
      "approved"
    end

    def type
      payment.type
    end

    def data
      text_value.strip
    end

    def reference
      "#{batch_reference}-#{account_number.text_value}-#{ref.text_value}"
    end

    def drn
      "#{account_number.text_value}#{ref.text_value}"
    end

    def batch_reference
      batch.reference
    end

    def batch
      parent.parent
    end

    def gateway
      "DEFT"
    end

    def source
      payment.source
    end
  end
end