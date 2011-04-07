class PostsController < ApplicationController
  
  caches_page :index, :news, :cover_stories, :popular, :sports, :business,
    :sports, :all_stories_feed, :news_stories_feed, :cover_stories_feed,
    :business_stories_feed, :sports_stories_feed, :blog_feed
  
  def index
    @posts = Post.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end
  
  def news
    @posts = Post.news.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end
  
  def cover_stories
    @posts = Post.cover.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end
  
  def popular
    @posts = Post.popular.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end  
  
  def sports
    @posts = Post.sports.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end

  def business
    @posts = Post.business.visible.all(:limit => 1000).paginate :per_page => 100, :page => params[:page]
  end

  def search
    @posts = Post.find_by_contents(params[:query], :limit => 100, :order => 'created_at DESC')
  end
  
  def read
    @post = Post.find(params[:id])
    @post.number_of_votes += 1
    @post.save
    redirect_to @post.url
  end

  def blog_feed
    @posts = Post.popular.visible.all(:limit => 20)
    render :layout => false    
  end

  def all_stories_feed
    @posts = Post.visible.all(:limit => 250)
    render :layout => false
  end
  
  def cover_stories_feed
    @posts = Post.cover.visible.all(:limit => 100)
    render :layout => false
  end

  def popular_stories_feed
    @posts = Post.popular.visible.all(:limit => 100)
    render :layout => false
  end
  
  def news_stories_feed
    @posts = Post.news.visible.all(:limit => 100)
    render :layout => false
  end
  
  def sports_stories_feed
    @posts = Post.sports.visible.all(:limit => 100)
    render :layout => false
  end
  
  def business_stories_feed
    @posts = Post.business.visible.all(:limit => 100)
    render :layout => false
  end    
end
