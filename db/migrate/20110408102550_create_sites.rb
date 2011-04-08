class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :url
      t.string :name
      t.string :dhivehi_name

      t.timestamps
    end
    Site.create(:url => "http://www.haveeru.com.mv", :name => "Haveeru", :dhivehi_name => "ހަވީރު")
    Site.create(:url => "http://www.haamadaily.com", :name => "Haama", :dhivehi_name => "ހާމަ")    
  end

  def self.down
    drop_table :sites
  end
end
