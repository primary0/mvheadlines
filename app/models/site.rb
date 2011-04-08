class Site < ActiveRecord::Base
  
  has_many :posts  
  
  validates_uniqueness_of :name

  #main
  
  def self.update_all
    update_haama_sports
    update_haveeru_sports
    update_haveeru_business
    update_haama
    update_haveeru
  end

  def self.update_sports
    update_haama_sports
    update_haveeru_sports
  end
  
  def self.update_business
    update_haveeru_business
  end
  
  # News
  
  def self.update_haama
    begin
      @site = HaamaDhivehiLocal.new
      @site.update
    rescue
    end
  end

  def self.update_haveeru
    begin
      @site = HaveeruDhivehiLocal.new
      @site.update
    rescue
    end
  end

  # Sports
    
  def self.update_haveeru_sports
    begin
      @site = HaveeruDhivehiSports.new
      @site.update
    rescue
    end
  end

  def self.update_haama_sports
    begin
      @site = HaamaDhivehiSports.new
      @site.update
    rescue
    end
  end
  
  # Business
    
  def self.update_haveeru_business
    begin
      @site = HaveeruDhivehiBusiness.new
      @site.update
    rescue
    end
  end
 
end
