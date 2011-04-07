class MinivanDhivehiLocal < NewsAgency
  attr_accessor :name, :home  
  
  def initialize
    @name = 'Minivan'
    @home = 'http://www.minivandaily.com'
    @home_page = ''
    @news_page = ''
    @links = []    
  end
  
  private

  def get_pages
    begin
      @home_page = Hpricot(open('http://www.minivandaily.com'))
      @news_page = Hpricot(open('http://www.minivandaily.com/index.php?option=com_content&task=category&sectionid=1&id=1&Itemid=47'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    
    # headline
    begin
    	link = {}
    	link['url'] = @home_page.at('#top_title//a')['href']
    	link['title'] = clean(@home_page.at('#top_title//a').inner_html, false)
      link['post_type'] = 'news'
    	link['cover'] = true	    
    	@links << link
    rescue
    	log_error("#{name} - Home page", "Unable to extract headline")
    end
    
    # more news on the news page
    # to loops for 2 row classes on the page (alternating colors stuff hahaha)
    begin
      @news_page.search("tr[@class='sectiontableentry2]//a").each do |block|
	      link = {}
	      link['url'] = block['href']
	      link['title'] = clean(block.inner_html, false)
        link['post_type'] = 'news'
	      @links << link    	
      end
      @news_page.search("tr[@class='sectiontableentry1]//a").each do |block|
	      link = {}
	      link['url'] = block['href']
	      link['title'] = clean(block.inner_html, false)
        link['post_type'] = 'news'
	      @links << link    	
      end      
      true
    rescue
      log_error("#{name} - Home page", "Unable to extract more news links")
      false
    end
  end
  
end
