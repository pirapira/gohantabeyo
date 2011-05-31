class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name, :limit => 30, :null => false

      t.timestamps
    end
    add_index :activities, [:name]
  end

  def self.down
    drop_table :activities
  end
end
