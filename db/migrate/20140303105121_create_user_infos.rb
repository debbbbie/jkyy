class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.integer :user_id
      t.string :idcard, :limit => 20
      t.string :qq, :limit => 20
      t.string :name, limit: 20
      t.boolean :sex
      t.date :birth
      t.string :reg_addr, :limit => 80
      t.string :mobile, :limit => 20
      t.string :cont_addr, :limit => 80
      t.string :che_xing, :limit => 20
      t.date :valid_start
      t.date :valid_end
      t.string :school, :limit => 50
      t.string :flow_no, :limit => 30
      t.string :status, :limit => 20

      t.timestamps
    end
  end
end
