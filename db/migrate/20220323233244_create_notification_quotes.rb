class CreateNotificationQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_quotes do |t|
      t.integer :user_id
      t.integer :quote_id

      t.timestamps
    end
  end
end
