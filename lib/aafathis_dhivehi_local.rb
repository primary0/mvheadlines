class AafathisDhivehiLocal < NewsAgency
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
      @home_page = Hpricot(open('http://www.aafathisnews.com.mv/nets/'))
      @news_page = Hpricot(open('http://aafathisnews.com.mv/nets/local/'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      # headline news found with with bidi-override attribute
      begin
        link = {}
        link['url'] = @home + @home_page.at("//a[@target='_parent']:last")['href']
        # link['title'] = clean(@home_page.at("//div[@class='net-main-story']//font[@face='A_Waheed']").inner_html, true)
        link['title'] = clean(@home_page.at("font[@unicode-bidi='bidi-override']").inner_html, true)
        link['post_type'] = 'news'
      	link['cover'] = true
      	@links << link
      rescue
	      log_error("#{name} - Home page", "Unable to extract headline")
      end
    
      # rightbar news links
      # extracted url needed modification before being joined with the home url
      begin
	      @news_page.search("div[@class='bigbox_view_Read']//table").each do |block|
          link = {}
          link['url'] = @home + block.at("//a")['href'].gsub(/(\.\.\/)/, '')
          link['title'] = clean(block.at("//font").inner_html, true)
          link['post_type'] = 'news'
          @links << link
	      end
      rescue
	      log_error("#{name} - News page", "Unable to exctarct sidebar links")
      end
    
      # more news. similar tree as rightbar, except the parent class
      # extracted url needed modification before being joined with the home url
     begin
	     @news_page.search("div[@class='CatsRead']//table").each do |block|
          link = {}
          link['url'] = @home + block.at("//a")['href'].gsub(/(\.\.\/)/, '')
          link['title'] = clean(block.at("//font").inner_html, true)
          link['post_type'] = 'news'
          @links << link
        end
      rescue
	      log_error("#{name} - News page", "Unable to extract more news links")
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
