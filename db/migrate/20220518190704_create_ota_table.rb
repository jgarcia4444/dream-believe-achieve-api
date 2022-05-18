class CreateOtaTable < ActiveRecord::Migration[7.0]
  def change
    create_table :ota do |t|
      t.integer :user_id
      t.string :code
      t.timestamps
    end
  end
end
