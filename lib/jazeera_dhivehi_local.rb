class JazeeraDhivehiLocal < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Jazeera'
    @home = 'http://www.jazeera.com.mv'
    @home_page = ''
    @news_page = ''
    @links = []    
  end

  def get_pages
    begin
      @home_page = Hpricot(open('http://www.jazeera.com.mv'))
      @news_page = Hpricot(open('http://www.jazeera.com.mv/categories/view/1'))
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
	      link['url'] = @home + @home_page.at("#homeMainNewsTitle//a")['href']
	      link['title'] = @home_page.at("#homeMainNewsTitle//a").inner_html
        link['post_type'] = 'news'
	      link['cover'] = true	    
	      @links << link
      rescue
	      log_error("#{name} - Home page", "Unable to extract headline")
      end
	
      # headline news on news page. main headline is also linked on the news page
      begin
	      link = {} 
	      link['url'] = @home + @news_page.at("#homeMainNewsTitle//a")['href']
	      link['title'] = @news_page.at("#homeMainNewsTitle//a").inner_html
        link['post_type'] = 'news'
	      @links << link
      rescue
	      log_error("#{name} - News page", "Unable to extract headline")
      end
	
      # sub news on the news page
      begin
	      @news_page.search("//h3/a").each do |block|
          link = {} 
          link['url'] = @home + block['href']
          link['title'] = block.inner_html
          link['post_type'] = 'news'
          @links << link
        end 
      rescue
        log_error("#{name} - News page", "Unable to extract sub news")
      end
	
      # more news on the news page
      begin
	      @news_page.search("#categoryViewContainerThree//li/a").each do |block|
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
