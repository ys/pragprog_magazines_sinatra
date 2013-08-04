class Magazine
  attr_accessor :issue, :title, :cover, :summary, :links
  def self.init_with_row(row)
    new.tap do |magazine|
      magazine.issue   = row.css('h3').text[/#(\d*)/, 1].to_i
      magazine.title   = row.css('h3').text.strip
      magazine.cover   = row.css('.magazine-cover').first.attr('src')
      magazine.summary = row.css('.summary').text.strip
      magazine.links   = row.css('.link a').map { |l| { type: l.text.downcase, url: l.attr('href') } }
    end
  end

  def self.init_with_hash(hash)
    new.tap do |magazine|
      magazine.issue   = hash.fetch('issue')
      magazine.title   = hash.fetch('title')
      magazine.cover   = hash.fetch('cover')
      magazine.summary = hash.fetch('summary')
      magazine.links   = hash.fetch('links')
    end
  end

  def to_json(opts = {})
    { issue: issue, title: title, cover: cover, summary: summary, links: links }.to_json(opts)
  end

end

