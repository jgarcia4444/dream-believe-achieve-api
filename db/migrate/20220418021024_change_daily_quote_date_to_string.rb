class ChangeDailyQuoteDateToString < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :daily_quote_date, :string
  end
end
