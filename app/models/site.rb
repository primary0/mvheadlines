class Site < ActiveRecord::Base
  
  has_many :posts  
  
  validates_uniqueness_of :name

  #main
  
  def self.update_all
    # no hamaroalhi sports
    # no minivan sports
    # update_raajje_sports
    # update_sangu_sports
    update_haama_sports
    update_miadhu_sports
    # update_jazeera_sports
    # update_aafathis_sports
    update_haveeru_sports

    # no hamaroalhi business
    # no minivan business
    # no miadhu business. error when the business link is clicked
    # no haama business
    # update_raajje_business
    # update_sangu_business
    # update_jazeera_business
    # update_aafathis_business
    update_haveeru_business

    # update_hamaroalhi
    # update_raajje
    # update_sangu
    update_haama
    update_miadhu
    # update_jazeera
    # update_minivan
    # update_aafathis
    update_haveeru
  end

  def self.update_sports
    # no hamaroalhi sports
    # no minivan sports
    # update_raajje_sports
    # update_sangu_sports
    update_haama_sports
    update_miadhu_sports
    # update_jazeera_sports    
    # update_aafathis_sports    
    update_haveeru_sports
  end
  
  def self.update_business
    # no hamaroalhi business
    # no minivan business
    # no miadhu business. error when the business link is clicked
    # no haama business
    # update_raajje_business
    # update_sangu_business
    # update_jazeera_business
    # update_aafathis_business
    update_haveeru_business
  end
  
  #news
  
  def self.update_raajje
    begin
      @site = RaajjeDhivehiLocal.new
      @site.update
    rescue
    end    
  end
  
  def self.update_hamaroalhi
    begin
      @site = HamaroalhiDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_sangu
    begin
      @site = SanguDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_haama
    begin
      @site = HaamaDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_miadhu
    begin
      @site = MiadhuDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_jazeera
    begin
      @site = JazeeraDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_minivan
    begin
      @site = MinivanDhivehiLocal.new
      @site.update
    rescue
    end
  end
  
  def self.update_aafathis
    begin
      @site = AafathisDhivehiLocal.new
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

  #sports
  def self.update_raajje_sports
    begin
      @site = RaajjeDhivehiSports.new
      @site.update
    rescue
    end    
  end  
  
  def self.update_haveeru_sports
    begin
      @site = HaveeruDhivehiSports.new
      @site.update
    rescue
    end
  end
  
  def self.update_aafathis_sports
    begin
      @site = AafathisDhivehiSports.new
      @site.update
    rescue
    end
  end
  
  def self.update_jazeera_sports
    begin
      @site = JazeeraDhivehiSports.new
      @site.update
    rescue
    end
  end
  
  def self.update_miadhu_sports
    begin
      @site = MiadhuDhivehiSports.new
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
  
  def self.update_sangu_sports
    begin
      @site = SanguDhivehiSports.new
      @site.update
    rescue
    end
  end
  
  # business
  def self.update_raajje_business
    begin
      @site = RaajjeDhivehiBusiness.new
      @site.update
    rescue
    end    
  end  
  
  def self.update_haveeru_business
    begin
      @site = HaveeruDhivehiBusiness.new
      @site.update
    rescue
    end
  end
  
  def self.update_aafathis_business
    begin
      @site = AafathisDhivehiBusiness.new
      @site.update
    rescue
    end
  end
  
  def self.update_jazeera_business
    begin
      @site = JazeeraDhivehiBusiness.new
      @site.update
    rescue
    end
  end

  def self.update_sangu_business
    begin
      @site = SanguDhivehiBusiness.new
      @site.update
    rescue
    end
  end  
  
end
