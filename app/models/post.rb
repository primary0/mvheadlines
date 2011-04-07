class Post < ActiveRecord::Base 
  
  belongs_to :site
  has_many :votes
  
  validates_presence_of :title, :url
  validates_uniqueness_of :title, :url  
  
  named_scope :visible, :conditions => ['invisible = ? ', false], :order => 'created_at DESC'  
  named_scope :popular, :conditions => ['number_of_votes >= ?', 5]
  named_scope :cover, :conditions => {:cover => true}
  named_scope :news, :conditions => {:post_type => 'news'}
  named_scope :business, :conditions => {:post_type => 'business'}
  named_scope :sports, :conditions => {:post_type => 'sports'}  
  
  named_scope :haveeru, :conditions => {:site_id => 1}
  named_scope :aafathis, :conditions => {:site_id => 2}
  named_scope :minivan, :conditions => {:site_id => 3}
  named_scope :haama, :conditions => {:site_id => 4}
  named_scope :miadhu, :conditions => {:site_id => 5}
  named_scope :jazeera, :conditions => {:site_id => 6}
  named_scope :sangu, :conditions => {:site_id => 7}
  named_scope :hamaroalhi, :conditions => {:site_id => 8}
  named_scope :raajje, :conditions => {:site_id => 9}
  
  named_scope :weekly_popular, :conditions => ['created_at > ?', 7.days.ago ], :order => 'number_of_votes DESC', :limit => 10
  named_scope :daily_popular, :conditions => ['created_at > ?', 24.hours.ago ], :order => 'number_of_votes DESC', :limit => 10
  named_scope :monthly_popular, :conditions => ['created_at > ?', 30.days.ago ], :order => 'number_of_votes DESC', :limit => 10    

  def url_exists?
    Post.find_by_url(url) ? true : false
  end
  
  def title_exists?
    Post.find_by_title(title) ? true : false
  end

  def duplicate_title_post_id
    duplicate_post_id = nil
    Post.find(:all, :limit => 250, :conditions => ['site_id = ?', self.site_id]).each do |post|
      if post.title[0..80] == self.title[0..80]
        duplicate_post_id = post.id
      end
    end
    duplicate_post_id
  end

end
