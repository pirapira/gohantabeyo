class CreateWishes < ActiveRecord::Migration
  def self.up
    create_table :wishes do |t|
      t.integer :wisher_id, :null => false
      t.string :wishee_tw_uid, :null => false
      t.integer :activity_id, :null => false

      t.timestamps
    end
    add_index :wishes, [:wisher_id, :wishee_tw_uid, :activity_id]
    add_index :wishes, [:activity_id]
  end

  def self.down
    drop_table :wishes
  end
end
