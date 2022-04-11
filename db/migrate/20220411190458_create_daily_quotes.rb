class CreateDailyQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_quotes do |t|
      t.integer :quote_id 
      t.integer :user_id 
      t.timestamps
    end
  end
end
