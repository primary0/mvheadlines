class HaveeruDhivehiBusiness < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Haveeru'
    @home = 'http://www.haveeru.com.mv'
    @home_page = ''
    @news_page = ''
    @links = []    
  end
  
  private

  def get_pages
    begin
      @news_page = Hpricot(open('http://www.haveeru.com.mv/?page=listcategory&cat=irWfwyiv'))      
      true
    rescue
      log_error("#{name} - Business", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      # cover story
      begin
        link = {}
        link['url'] = @home + @news_page.at("font[@class='atheadline']//a")['href']
        link['title'] = clean(@news_page.at("font[@class='atheadline']//a").inner_html, true)
        link['post_type'] = 'business'
        @links << link      
      rescue
        log_error("#{name} - Business", "Extracting sports cover story")
      end
      
      # more links at the bottom
      begin
        @news_page.search("div[@class='newslistingcat']//li/a").each do |block|
          link = {}
          link['url'] = @home + block['href'] #wtf the links have full path in the URL in this div.lol!
          link['title'] = clean(block.at("font").inner_html, true)
          link['post_type'] = 'business'
          @links << link
        end      
      rescue
        log_error("#{name} - Business", "Unable to extract more new links")      
      end
    
      # today's sports news on the side!
      begin
        @news_page.search("div[@class='subnews']").each do |block|
          link = {}
          link['url'] = @home + block.at("font/a")['href']
          link['title'] = clean(block.at("font/a").inner_html, true)
          link['post_type'] = 'business'
          @links << link
        end
      rescue
        log_error("#{name} - business", "Unable to extract links on the left side")
      end  
      
    true
    rescue
      false
    end
  end
  
  def get_description(link)
    begin
      @page = Hpricot(open(link['url']))      
      link['real_title'] = clean(@page.at("#heading//font").inner_html, true)      
      @article = @page.at("#news//div[@class='thaana']").inner_html
      @article = @article.gsub(/<font[^>]*>/, "")
      @article = @article.gsub(/<\/font>/, "")
      @article = @article.gsub(/&#40;/, "(")
      @article = @article.gsub(/&#41;/, ")")
      @article = @article.gsub(/((\s*)<br \/>(\s*)<br \/>(\s*))+/, "<br />")
      link['description'] = clean(@article, true)
      return link
    rescue
      return link
    end
  end
end
