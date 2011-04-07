class SanguDhivehiLocal < NewsAgency
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
      @home_page = Hpricot(open('http://www.sangudaily.com/'))
      @news_page = Hpricot(open('http://www.sangudaily.com/category.php?id=3'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    coder = HTMLEntities.new
    begin
      # headline news on home page. main headline is also linked on the news page     
      begin
        @home_page.search("div[@class='dhiv_main']/a").each do |block|
          link = {} 
  	      link['url'] = @home + block['href']
  	      link['title'] = reverse_numbers(coder.decode(block.inner_html).strip)
          link['post_type'] = 'news' 
  	      @links << link
        end        
      rescue
	      log_error("#{name} - Home page", "Unable to extract headline")
      end
	
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
	      log_error("#{name} - News page", "Unable to extract more news")
      end
      true
    rescue
      false
    end
  end  
end
