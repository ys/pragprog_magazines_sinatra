require 'nokogiri'
require 'open-uri'
require 'json'
require 'sinatra'
require 'redis'

uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

class Magazine
  attr_accessor :title, :cover, :summary, :links
  def self.init_with_row(row)
    new.tap do |magazine|
      magazine.title   = row.css('h3').text.strip
      magazine.cover   = row.css('.magazine-cover').first.attr('src')
      magazine.summary = row.css('.summary').text.strip
      magazine.links   = row.css('.link a').map { |l| { type: l.text.downcase, url: l.attr('href') } }
    end
  end

  def to_json(opts = {})
    { title: title, cover: cover, summary: summary, links: links }.to_json(opts)
  end

end

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

get '/' do
  content_type :json
  if REDIS.get('magazines')
    REDIS.get('magazines')
  else
    Magazines.new.get_all.to_json.tap do |magazines|
      REDIS.setex 'magazines', 3600 * 24,  magazines
    end
  end
end

