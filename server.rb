require 'json'
require 'sinatra'
require 'redis'
require_relative 'magazines'
require_relative 'magazines_fetcher'

uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://localhost:6379')
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

get '/', &MagazinesFetcher
