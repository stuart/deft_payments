module DeftPayments
  class PayFileResponse
    
    attr_accessor :http_response

    def initialize http_response
      @http_response = http_response
    end

    def success?
      http_response.code == "200"
    end

    def valid?
      pay_file
    end

    def body
      http_response.body
    end

    def transactions
      pay_file.transactions
    end

private
    def pay_file
      @pay_file ||= PayFileParser.new.parse body
    end
  end
end