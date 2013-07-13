require 'nokogiri'
require 'open-uri'
require_relative 'magazine'

class Magazines
  def initialize
    @doc = Nokogiri::HTML(open('http://pragprog.com/magazines'))
  end

  def page(id)
    Nokogiri::HTML(open("http://pragprog.com/magazines?page=#{id}"))
  end

  def get_all
    i = 0
    @@magazines = []
    loop do
      doc = page(i)
      magazines_rows = doc.css('.magazines tr')
      break unless magazines_rows.any?
      magazines_rows.each do |magazine_row|
        @@magazines << Magazine.init_with_row(magazine_row)
      end
      i += 1
    end
    @@magazines
  end
end

