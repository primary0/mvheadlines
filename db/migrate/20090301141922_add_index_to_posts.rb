class AddIndexToPosts < ActiveRecord::Migration
  def self.up
    add_index :posts, :id
  end

  def self.down
  end
end