class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.integer :site_id
      t.integer :hits
      t.boolean :cover, :default => false
      t.integer :number_of_votes, :default => 0
      t.string :post_type
      t.string :real_title
      t.boolean :invisible, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
