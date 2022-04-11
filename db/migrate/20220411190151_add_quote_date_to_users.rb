class AddQuoteDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :daily_quote_date, :time
  end
end
