class HaamaDhivehiLocal < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Haama'
    @home = 'http://www.haamadaily.com/'  
    @home_page = ''
    @news_page = ''
    @links = []    
  end
  
  private

  def get_pages
    begin
      @home_page = Hpricot(open('http://www.haamadaily.com'))
      @news_page = Hpricot(open('http://www.haamadaily.com/index.php?category=3'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links    
    begin  
      
      # home page, main headline
      begin
        link = {}
        link['url'] = @home_page.at("td[@class='latestsumary']:first//a")['href']
        link['title'] = @home_page.at("td[@class='mainsuruhi']//div").inner_html
        link['post_type'] = 'news'
        link['cover'] = true	    
        unless link['url'] =~ /^http/
          link['url'] = @home + link['url']
        end        
        @links << link
      rescue
        log_error("#{name} - Home page", "Unable to extract headline")
      end
    
      #news page main headline    
      begin
        link = {}
        link['url'] = @news_page.at("td[@class='sumary']/div/a")['href']
        link['title'] = @news_page.at("td[@class='mainsuruhi']/div").inner_html
        link['post_type'] = 'news'
        link['cover'] = true
        # some links do not contain the full path, some do. this is the cleanup
        unless link['url'] =~ /^http/
          link['url'] = @home + link['url']
        end
        @links << link    
      rescue
      end
  
      # full xpath on news page! risky though :S
      begin
        @news_page.search("/html/body/table[2]/tr/td[5]/table/tr[3]/td/div/div//a").each do |block|
          link = {}
          link['url'] = block['href']
          link['title'] = clean(block.inner_html, false)
          link['post_type'] = 'news'
          unless link['url'] =~ /^http/
            link['url'] = @home + link['url']
          end          
          @links << link
        end    
      rescue
        log_error("#{name} - News Page", "Unable to extract more news links")
      end
  
      true
    rescue
      false
    end
  end
end
