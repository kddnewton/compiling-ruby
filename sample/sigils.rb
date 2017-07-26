require 'date'
require 'uri'

module Sigils
  def self.date
    ~d(January 1st, 2017) == Date.parse('2017-01-01')
  end

  def self.uri
    ~u(http://google.com) == URI.parse('http://google.com')
  end
end
