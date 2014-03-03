# coding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :limit => 20
      t.string :account, :limit => 20
      t.string :pwd, :limit => 20
      t.string :mobile, :limit => 20
      t.timestamps
    end
  end
end
