require 'poncho'

class MagazinesFetcher < Poncho::Method

  def invoke
    status 200
    content_type :json
    Magazines.new.load_all.to_json
  end
end

