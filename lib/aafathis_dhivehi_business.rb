class AafathisDhivehiBusiness < NewsAgency
  attr_accessor :name, :home
  
  def initialize
    @name = 'Aafathis'
    @home = 'http://www.aafathisnews.com.mv/nets/'
    @home_page = ''
    @news_page = ''
    @links = []    
  end
  
  private
  
  def get_pages
    begin
      @news_page = Hpricot(open('http://aafathisnews.com.mv/nets/business/'))
      true
    rescue
      log_error("#{name} - business", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      
    # more news. similar tree as rightbar, except the parent class
    # extracted url needed modification before being joined with the home url
      begin
        @news_page.search("div[@class='CatsRead']//table").each do |block|
          link = {}
          link['url'] = @home + block.at("//a")['href'].gsub(/(\.\.\/)/, '')
          link['title'] = clean(block.at("//font").inner_html, true)
          link['post_type'] = 'business'
          @links << link
        end
      rescue
        log_error("#{name} - business", "Unable to extract more news links")
      end
      
      true
    rescue
      false
    end
  end
  
  def get_description(link)
    begin
      @page = Hpricot(open(link['url']))      
      link['real_title'] = clean(@page.at("a[@class='read_headline']").inner_html, true)      
      @article = @page.search("div[@class='leftRead']//font").last.inner_html
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