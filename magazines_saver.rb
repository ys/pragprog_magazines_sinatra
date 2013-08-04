require 'poncho'

class MagazinesSaver < Poncho::Method

  def invoke
    status 200
    content_type :json
    Magazines.new.save_all.to_json
  end
end

