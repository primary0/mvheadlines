class NewsAgency
  
  require 'rubygems'
  require 'hpricot'
  require 'open-uri'
  require 'htmlentities'
  require 'strscan'
  
  attr_accessor :links, :crawler_log
  
  def crawler_log
    @crawler_log = File.new("#{RAILS_ROOT}/log/crawler.log", 'a')
  end
  
  # This is one long ugly method.
  
  def update
    if get_pages
      if get_links
        @site = Site.find_by_name(@name)
        @links.each do |link|
          @post = Post.new
          @post.url = link['url']
          @post.title = link['title']
          @post.post_type = link['post_type']
          dupe_id = @post.duplicate_title_post_id
          if link['cover'] == true
            @post.cover = true
          else
            @post.cover = false
          end
          if @post.url_exists?
            @previous_post = Post.find_by_url(@post.url)
            @previous_post.title = @post.title
            if @post.cover == true
              @previous_post.cover = @post.cover
            end
            @previous_post.save
          elsif @post.title_exists?
            if @post.url_exists?
              @post.destroy
            else
              @previous_post = Post.find_by_title(@post.title)
              @previous_post.url = @post.url
              if @post.cover == true
                @previous_post.cover = @post.cover
              end
              @previous_post.save
            end
          elsif dupe_id != nil
            @previous_post = Post.find(dupe_id)
            @previous_post.url = @post.url
            if @post.cover == true
              @previous_post.cover = @post.cover
            end
            @previous_post.save
          else
            @post.site = @site
            # @post = get_description(@post)
            @post.save
          end
        end
        log_notice("#{@name} - System", "Finished adding new links to the database")
      else
        log_error("#{@name} - System", "No links extracted")
      end
    else
      log_error("#{@name} - System", "Unable to retrieve pages")
    end
  end

  def log_error(caller, message)
    crawler_log.puts "#{Time.now} ERROR : #{caller} - #{message}"
  end
  
  def log_notice(caller, message)
    crawler_log.puts "#{Time.now} NOTICE : #{caller} - #{message}"
  end
  
  def substringer(old, new)
    old = old.gsub(/(\.+)/, '').strip
    new = new.gsub(/(\.+)/, '').strip
    if old.include? new
      true
    elsif new.include? old
      true
    else
      false
    end
  end
  
  def clean(string,to_convert)
    string = string.gsub(/(<.+>)/, '').strip
    if to_convert == true
      string = convert(string)
    end
    string
  end
    
  def reverse_numbers(numbers)
    numbers = numbers.gsub(/\d+\S+/) {|digits| digits.reverse}
    numbers
  end

  def convert(ttf)
    
    # waheed - unicode reference hash
  
  	x = {}
  	x['a'] = 1927
  	x['A'] = 1954
	
  	x['b'] = 1924
  	x['B'] = 1950
	
  	x['c'] = 1968
  	x['C'] = 1943
	  
  	x['d'] = 1931
  	x['D'] = 1937
	
  	x['e'] = 1964
  	x['E'] = 1965
	
  	x['f'] = 1930
  	x['F'] = 1951
	
  	x['g'] = 1934
  	x['G'] = 1955
	
  	x['h'] = 1920
  	x['H'] = 1945
	
  	x['i'] = 1960
  	x['I'] = 1961
	
  	x['j'] = 1942
  	x['J'] = 1947
	
  	x['k'] = 1926
  	x['K'] = 1946
	
  	x['l'] = 1933
  	x['L'] = 1925
	
  	x['m'] = 1929 # <--- repeated!
  	x['M'] = 1929
	
  	x['n'] = 1922
  	x['N'] = 1935
	
  	x['o'] = 1966
  	x['O'] = 1967
	
  	x['p'] = 1941 # <--- repeated :S
  	x['P'] = 1941
	
  	x['q'] = 1956
  	x['Q'] = 65010
	
  	x['r'] = 1923
  	x['R'] = 1948
	
  	x['s'] = 1936
  	x['S'] = 1921
	
  	x['t'] = 1932
  	x['T'] = 1939
	
  	x['u'] = 1962
  	x['U'] = 1963
	
  	x['v'] = 1928
  	x['V'] = 1957
	
  	x['w'] = 1958
  	x['W'] = 1959
	
  	x['x'] = 1949
  	x['X'] = 1944
	
  	x['y'] = 1940
  	x['Y'] = 1952
	
  	x['z'] = 1938
  	x['Z'] = 1953

  	x['0'] = 48
  	x['1'] = 49
  	x['2'] = 50
  	x['3'] = 51
  	x['4'] = 52
  	x['5'] = 53
  	x['6'] = 54
  	x['7'] = 55
  	x['8'] = 56
  	x['9'] = 57
	
  	x['~'] = 126
  	x['`'] = 96
  	x['!'] = 33
  	x['@'] = 64
  	x['#'] = 35
  	x['$'] = 36
  	x['%'] = 37
  	x['^'] = 94
  	x['&'] = 38
  	x['*'] = 42
  	x['('] = 40
  	x[')'] = 41
  	x['-'] = 45
  	x['_'] = 95
  	x['='] = 61
  	x['+'] = 43
	
  	x['['] = 91
  	x[']'] = 93
  	x['{'] = 123
  	x['}'] = 125
  	x['|'] = 124
  	x["\\"] = 92
  	x[';'] = 59
  	x[':'] = 58
  
    #quotes!
  
  	x['"'] = 39
  	x["'"] = 39
  
  	x[','] = 44
  	x['.'] = 46
  	x['<'] = 60
  	x['>'] = 62
  	x['/'] = 47
  	x['?'] = 63
  	x[' '] = 32	  
        
  	utf = ''	
  	ttf = ttf.gsub(/\s/, ' ').strip
	
  	# Clean up numerics mixed up with alpha without spaces. News editor mistakes
  	ttf = ttf.gsub(/(\d+)([A-Za-z]+)/, "\\1 \\2")
  	ttf = ttf.gsub(/([A-Za-z]+)(\d+)/, "\\1 \\2")
  	ttf = ttf.gsub(/([A-Za-z]+)(\d+)([A-Za-z]+)/, "\\1 \\2 \\3")
  
    # Clean up non ASCII
    ttf = ttf.gsub(/([^\x20-\x7E])/, ' ')
   
    # Replace quotes
    ttf = ttf.gsub(/(&quot;)/, "'")
  
  	ttf.split('').each do |char|
  	  if char == ' '
  	    utf << [32].pack("U")
            else
  	    utf << [x[char]].pack("U")    
  	  end
  	end	
  	
  	utf = utf.gsub(/\d+\S+/) {|digits| digits.reverse}
  	utf = utf.strip        
  	return utf
  	
  end
end
