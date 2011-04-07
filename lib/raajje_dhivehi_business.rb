class RaajjeDhivehiBusiness < NewsAgency
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
      @news_page = Hpricot(open('http://www.raajjedaily.com/section-8.htm'))
      true
    rescue
      log_error("#{name} - Business", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin	
      # more news on the news page
      begin
	      @news_page.search("#newslist/a").each do |block|
          link = {} 
          link['url'] = @home + block['href']
          link['title'] = block.inner_html
          link['post_type'] = 'business'
          @links << link
        end
      rescue
	      log_error("#{name} - Business", "Unable to extract more news")
      end
      
      true
    rescue
      false
    end
  end  
end
