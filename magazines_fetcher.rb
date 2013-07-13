require 'poncho'

class MagazinesFetcher < Poncho::Method

  def invoke
    status 200
    content_type :json

    if REDIS.exists('magazines')
      REDIS.get('magazines')
    else
      Magazines.new.get_all.to_json.tap do |magazines|
        REDIS.setex 'magazines', 3600 * 24,  magazines
      end
    end
  end
end

