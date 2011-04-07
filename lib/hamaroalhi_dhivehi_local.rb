class HamaroalhiDhivehiLocal < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Hamaroalhi'
    @home = 'http://hamaroalhi.com.mv/'
    @home_page = ''
    @news_page = ''
    @links = []    
  end

  def get_pages
    begin
      @home_page = Hpricot(open('http://hamaroalhi.com.mv/'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    coder = HTMLEntities.new
    x = 1 # used to count iteration. first link is the main headline
    begin
      @home_page.search("//.Dhi_headlines//a").each do |block|
	      link = {}
	      link['url'] = @home + block['href']
	      link['title'] = reverse_numbers(coder.decode(block.inner_html.gsub(/(<.+>)/, '').strip).strip)
        link['post_type'] = 'news'
        if x == 1
          link['cover'] = true
        end
        x += 1
	      @links << link
      end
    rescue
      log_error("#{name} - Home page", "Unable to extract news")
    end
    true
  rescue
    false
  end
end
