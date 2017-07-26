require 'uri'

module Sigils
  def self.uri
    ~u(http://google.com) == URI.parse('http://google.com')
  end
end
