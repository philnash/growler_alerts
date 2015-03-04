require "nokogiri"
require "open-uri"

class ClaptonCraft
  def initialize(uri)
    @uri = uri
  end

  def growlers
    get_list("growlers")
  end

  def bottles
    get_list("bottles")
  end

  private

  def get_page
    @page ||= Nokogiri::HTML(open(@uri))
  end

  def get_list(type)
    beers = get_page.css(".#{type}_list h4")
    beers.map { |beer| beer.children.first.text.strip }
  end
end
