require 'treetop'
require 'money'

require File.join(File.dirname(__FILE__),'lib','pay_file_parser')
require File.join(File.dirname(__FILE__),'lib','transaction')
require File.join(File.dirname(__FILE__),'lib','pay_file_request')
require File.join(File.dirname(__FILE__),'lib','pay_file_response')

module DeftPayments
  class DeftPayments
    def self.fetch_pay_file date, options
      req  = PayFileRequest.new options.merge(date: date)
      resp = PayFileResponse.new(req.post)
      resp.transactions if resp.success? && resp.valid?
    end
  end
end