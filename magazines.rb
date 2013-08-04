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
    magazines = []
    loop do
      doc = page(i)
      magazines_rows = doc.css('.magazines tr')
      break unless magazines_rows.any?
      magazines_rows.each do |magazine_row|
        magazines << Magazine.init_with_row(magazine_row)
      end
      i += 1
    end
    magazines
  end

  def save_all
    get_all.each do |mag|
      REDIS.zadd :magazines, mag.issue, mag.to_json
    end
  end

  def fetch_new
    doc = page(i)
    magazines_rows = doc.css('.magazines tr')
    magazines_rows.each do |magazine_row|
      m = Magazine.init_with_row(magazine_row)
      REDIS.zadd :magazines, m.issue, m.to_json
    end
  end

  def load_all
    REDIS.zrevrange(:magazines, 0, -1).map do |magazine_hash|
      Magazine.init_with_hash(JSON.parse(magazine_hash))
    end
  end
end

