class Quote < ApplicationRecord 

    has_many :favorites, dependent: :destroy
    
    def self.filter_quotes(daily_quote_ids)
        all_quotes = Quote.all
        all_quotes.select {|quote| !daily_quote_ids.any? {|daily_quote_id| daily_quote_id == quote.id}}
    end
end