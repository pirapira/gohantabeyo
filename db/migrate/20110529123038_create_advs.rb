class CreateAdvs < ActiveRecord::Migration
  def self.up
    create_table :advs do |t|
      t.integer :user_id, :null => false
      t.integer :activity_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :advs
  end
end
