ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => "posts"
  map.connect 'covers', :controller => "posts", :action => 'cover_stories'
  map.connect 'popular', :controller => "posts", :action => 'popular'
  map.connect 'search', :controller => 'posts', :action => 'search'
  map.connect 'sports', :controller => 'posts', :action => 'sports'
  map.connect 'business', :controller => 'posts', :action => 'business'
  map.connect 'news', :controller => 'posts', :action => 'news'
  
  #index page pagination
  map.connect '/:page',
    :controller => 'posts',
    :action => 'index',
    :requirements => { :page => /\d+/}

  #covers page pagination
  map.connect 'covers/:page',
    :controller => 'posts',
    :action => 'cover_stories',
    :requirements => { :page => /\d+/}

  #popular page pagination
  map.connect 'popular/:page',
    :controller => 'posts',
    :action => 'popular',
    :requirements => { :page => /\d+/}
  
  #news page pagination
  map.connect 'news/:page',
    :controller => 'posts',
    :action => 'news',
    :requirements => { :page => /\d+/}  

  #business page pagination
  map.connect 'business/:page',
    :controller => 'posts',
    :action => 'business',
    :requirements => { :page => /\d+/}
  
  #sports page pagination
  map.connect 'sports/:page',
    :controller => 'posts',
    :action => 'sports',
    :requirements => { :page => /\d+/}
  
  #feeds
  map.connect 'feed.xml', :controller => 'posts', :action => 'all_stories_feed'
  map.connect 'all.xml', :controller => 'posts', :action => 'all_stories_feed'
  map.connect 'covers.xml', :controller => 'posts', :action => 'cover_stories_feed'
  map.connect 'popular.xml', :controller => 'posts', :action => 'popular_stories_feed'
  map.connect 'news.xml', :controller => 'posts', :action => 'news_stories_feed'
  map.connect 'business.xml', :controller => 'posts', :action => 'business_stories_feed'
  map.connect 'sports.xml', :controller => 'posts', :action => 'sports_stories_feed'
  map.connect 'posts.xml', :controller => 'posts', :action => 'blog_feed'
  
  #voting
  map.connect '/read/:id', :controller => 'posts', :action => 'read', :id => 'id'
  
  #reading
  map.connect '/view/:id', :controller => 'posts', :action => 'view', :id => 'id'
end
