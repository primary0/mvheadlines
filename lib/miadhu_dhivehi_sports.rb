class MiadhuDhivehiSports < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Miadhu'
    @home = 'http://www.miadhu.com.mv/div/'
    @home_page = ''
    @news_page = ''
    @links = []    
  end

  def get_pages
    begin
      @home_page = Hpricot(open('http://www.miadhu.com.mv/div/section.php?id=5'))
      true
    rescue
      log_error("#{name} - Sports", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      # more news on the home page
      begin
        @home_page.search("#mBody/table[2]//a").each do |block|
          link = {} 
          link['url'] = @home + block['href']
          link['title'] = clean(block.at("div").inner_html, true)
          link['post_type'] = 'sports'
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
