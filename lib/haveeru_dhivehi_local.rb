class HaveeruDhivehiLocal < NewsAgency
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
      @home_page = Hpricot(open('http://www.haveeru.com.mv'))
      @news_page = Hpricot(open('http://www.haveeru.com.mv/?page=categories&cat=urwbwK'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin  
      # headline news in font class "atheadline"
      begin
	link = {}
	link['url'] = @home + @home_page.at("font[@class='atheadline']/a")['href']
	link['title'] = clean(@home_page.at("font[@class='atheadline']/a/font").inner_html, true)
        link['post_type'] = 'news'
	link['cover'] = true	    
	@links << link
      rescue
	log_error("#{name} - Home page", "Unable to extract headline")
      end
    
      # subnews headlines
      begin
	@home_page.search("font[@class='subnewsheadline']//a").each do |block|
          link = {}
          link['url'] = block['href']
          link['title'] = clean(block.inner_html, true)
          link['post_type'] = 'news'
          unless link['url'] =~ /^http/
            link['url'] = @home + link['url']
          end   
          @links << link
	end
      rescue
	log_error("#{name} - Home page", "Unable to extract link at the bottom")
      end
    
      # links on the sidebar
      begin
	      @home_page.search('#newslisting//a').each do |block|
          link = {}
          link['url'] = @home + block['href']
          link['title'] = clean(block.search('font').inner_html, true)
          link['post_type'] = 'news'
          @links << link
	      end
      rescue
	      log_error("#{name} - Home page", "Unable to extract sidebar links")
      end
    
      # yet another cover story found on the news page
      begin
	      link = {}
	      link['url'] = @home + @news_page.at("font[@class='atheadline']/font/a")['href']
	      link['title'] = clean(@news_page.at("font[@class='atheadline']/font/a/font/font").inner_html, true)
        link['post_type'] = 'news'
	      link['cover'] = true
	      @links << link      
      rescue
	      log_error("#{name} - News page", "Extracting secondary cover story")
      end
    
      # more news links at the bottom
      begin
	      @news_page.search("div[@class='mainrightdiv']//a").each do |block|
          # there are garbage/blank links and stuff out there. so, avoid them!
          unless block.search("div[@class='thaana']/font").nil?
            unless block.search("div[@class='thaana']/font").empty?
              link = {}
              link['url'] = @home + block['href']
              link['title'] = clean(block.search("div[@class='thaana']/font").inner_html, true)
              link['post_type'] = 'news'
              @links << link
            end
          end	
        end
      rescue
	      log_error("#{name} - News page", "Unable to extract more new links")
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
