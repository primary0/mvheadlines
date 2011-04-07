class SanguDhivehiSports < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Sangu'
    @home = 'http://www.sangudaily.com/'
    @home_page = ''
    @news_page = ''
    @links = []    
  end

  def get_pages
    begin
      @news_page = Hpricot(open('http://www.sangudaily.com/category.php?id=5'))
      true
    rescue
      log_error("#{name} - Sports", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    coder = HTMLEntities.new
    begin
	
      # more news on the news page
      begin
        @news_page.search("div[@class='dhiv_main']/a").each do |block|
          link = {} 
  	      link['url'] = @home + block['href']
  	      link['title'] = reverse_numbers(coder.decode(block.inner_html).strip)
          link['post_type'] = 'news' 
  	      @links << link
        end
      rescue
	      log_error("#{name} - Sports", "Unable to extract more news")
      end
      true
    rescue
      false
    end
  end  
end
