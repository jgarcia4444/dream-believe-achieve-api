class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :quote

    def self.find_top_ten
        favorites = Favorite.all
        sorting_object = {}

        favorites.each do |favorite|
            quote_id = favorite.quote_id
            if sorting_object[quote_id]
                sorting_object[quote_id] += 1
            else
                sorting_object[quote_id] = 1
            end
        end

        sorted_quote_ids = sorting_object.keys.sort {|a, b| sorting_object[:b] <=> sorting_object[:a]}
        sorted_quotes = sorted_quote_ids.map {|quote_id| Quote.find_by(id: quote_id)}
        if sorted_quote.count > 10
            sorted_quotes.slice(0, 10).map do |quote|
                favorites_count = quote.favorites.count
                {
                    id: quote.id,
                    author: quote.author,
                    quote: quote.quote,
                    favorites: favorites_count
                }
            end
        else
            sorted_quotes.map do |quote|
                favorites_count = quote.favorites.count
                {
                    id: quote.id,
                    author: quote.author,
                    quote: quote.quote,
                    favorites: favorites_count
                }
            end
        end
    end

end