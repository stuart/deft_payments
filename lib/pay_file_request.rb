require "net/https"
require "uri"

module DeftPayments
  # Makes a post request to Macquarie bank to get the DEFT pay file.
  # You need to supply username, password, customer number and date (as a Time object)
  # in the options hash.
  #
  # Passing in a uri to the config can be used for testing.
  #
  class PayFileRequest
    attr_accessor :username, :password, :customer_number, :date, :base_uri, :connection

    def initialize config
      @username        = config[:username]
      @password        = config[:password]
      @customer_number = config[:customer_number]
      @date            = config[:date]
      @base_uri        = config[:uri] || "https://www.macquarie.com.au/ab3directdownload/download?"
    end

    def uri
      URI.parse(base_uri << query_string)
    end

    def query_string
      "username=#{username}&password=#{password}&customerNumber=#{customer_number}&fileType=P&fileDate=#{formatted_date}"
    end

    def formatted_date
      date.strftime("%Y-%m-%d")
    end

    def post
      connection.request(Net::HTTP::Post.new(uri.request_uri))
    end

    def connection
      @connection ||= http_connection
    end

    def http_connection
      http = Net::HTTP.new(uri.host, uri.port)
      #http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end


