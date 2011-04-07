class RaajjeDhivehiLocal < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Raajje'
    @home = 'http://www.raajjedaily.com/'
    @home_page = ''
    @news_page = ''
    @links = []    
  end

  def get_pages
    begin
      @home_page = Hpricot(open('http://www.raajjedaily.com/'))
      @news_page = Hpricot(open('http://www.raajjedaily.com/section-1.htm'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      # headline news on home page.
      begin
        link = {} 
	      link['url'] = @home + @home_page.at("p[@class='newsboxb-title']/a")['href']
	      link['title'] = @home_page.at("p[@class='newsboxb-title']/a").inner_html
        link['post_type'] = 'news'
	      link['cover'] = true	    
	      @links << link
      rescue
	      log_error("#{name} - Home page", "Unable to extract headline")
      end
	
      # more news on the news page
      begin
	      @news_page.search("#newslist/a").each do |block|
          link = {} 
          link['url'] = @home + block['href']
          link['title'] = block.inner_html
          link['post_type'] = 'news'
          @links << link
        end
      rescue
	      log_error("#{name} - News page", "Unable to extract more news")
      end
      
      true
    rescue
      false
    end
  end  
end
