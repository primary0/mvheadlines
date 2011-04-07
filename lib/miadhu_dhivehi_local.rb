class MiadhuDhivehiLocal < NewsAgency
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
      @home_page = Hpricot(open('http://www.miadhu.com.mv/div/'))
      true
    rescue
      log_error("#{name} - Site", "Unable to fetch pages")
      false
    end
  end
  
  def get_links
    begin
      # headline news on home page. main headline is also linked on the news page
      begin
      	link = {} 
      	link['url'] = @home_page.at("//table[2]//a")['href']
      	link['title'] = clean(@home_page.at("//table[2]//h2").inner_html, true)
        link['post_type'] = 'news'
	      link['cover'] = true	    
	      @links << link
      rescue
	      log_error("#{name} - Home page", "Unable to extract headline")
      end
	
      # sub news on the home page
      # couldn't figure out a logical loop for this... no choice :(
      begin
	      link = {}
	      link['title'] = clean(@home_page.at("table:eq(2)//td:eq(0)/h3:eq(0)").inner_html, true)
	      link['url'] = @home + @home_page.at("table:eq(2)//td:eq(0)/p:eq(0)/a")['href'].gsub(/http:\/\/www.miadhu.com.mv\/div\//, '').gsub(/(\/)/, '')
        link['post_type'] = 'news'
	      @links << link
	    
	      link = {}
	      link['title'] = clean(@home_page.at("table:eq(2)//td:eq(0)/h3:eq(1)").inner_html,true)
	      link['url'] = @home + @home_page.at("table:eq(2)//td:eq(0)/p:eq(1)/a")['href'].gsub(/http:\/\/www.miadhu.com.mv\/div\//, '').gsub(/(\/)/, '')
        link['post_type'] = 'news'
	      @links << link
	    
	      link = {}
	      link['title'] = clean(@home_page.at("table:eq(2)//td:eq(1)/h3:eq(0)").inner_html, true)
	      link['url'] = @home + @home_page.at("table:eq(2)//td:eq(1)/p:eq(0)/a")['href'].gsub(/http:\/\/www.miadhu.com.mv\/div\//, '').gsub(/(\/)/, '')
        link['post_type'] = 'news'
	@links << link

      	link = {}
      	link['title'] = clean(@home_page.at("table:eq(2)//td:eq(1)/h3:eq(1)").inner_html, true)
      	link['url'] = @home + @home_page.at("table:eq(2)//td:eq(1)/p:eq(1)/a")['href'].gsub(/http:\/\/www.miadhu.com.mv\/div\//, '').gsub(/(\/)/, '')
        link['post_type'] = 'news'
	@links << link
      rescue
	      log_error("#{name} - Home page", "Unable to extract sub news")
      end
	
      # more news on the home page
      begin
	      @home_page.search("table:eq(3)//a").each do |block|
          link = {} 
          link['url'] = @home + block['href']
          link['title'] = clean(block.at("div").inner_html, true)
          link['post_type'] = 'news'
          @links << link
        end
      rescue
        log_error("#{name} - Home page", "Unable to extract more news")
      end
      true
    rescue
      false
    end
  end
end
