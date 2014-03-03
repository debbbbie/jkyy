class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id, :null => false
      t.integer :yuyue_type, :null => false
      t.string :yuyue_at, :null => false
      t.integer :price
      t.integer :status
      #t.datetime :start_at
      #t.datetime :end_at
      t.integer :referee_id
      t.integer :referee_fee
      t.string :valid_code, :limit => 20

      t.timestamps
    end
  end
end
