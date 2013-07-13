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

