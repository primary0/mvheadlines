class HaamaDhivehiSports < NewsAgency
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
      @news_page = Hpricot(open('http://www.haamadaily.com/index.php?category=5'))
      true
    rescue
      log_error("#{name} - Sports", "Unable to fetch pages")
      false
    end
  end
  
  def get_links    
    begin  
    
      #news page main headline    
      begin
        link = {}
        link['url'] = @news_page.at("td[@class='sumary']/div/a")['href']
        link['title'] = @news_page.at("td[@class='mainsuruhi']/div").inner_html
        link['post_type'] = 'sports'
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
          link['post_type'] = 'sports'
          unless link['url'] =~ /^http/
            link['url'] = @home + link['url']
          end    
          @links << link
        end    
      rescue
        log_error("#{name} - Sports", "Unable to extract more news links")
      end
      true
      
    rescue
      false
    end
  end
end
