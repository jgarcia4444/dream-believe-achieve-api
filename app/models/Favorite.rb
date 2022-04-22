class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :quote

    def self.find_top_ten

        quotes_with_favorites = []
        Favorite.all.each do |favorite|
            if !quotes_with_favorites.any? {|quote| quote.id === favorite.quote_id}
                quote = Quote.find_by(id: favorite.quote_id)
                quotes_with_favorites.append(quote)
            end
        end

        sorted_quotes = quotes_with_favorites.sort {|a, b| a.favorites.count <=> b.favorites.count}.reverse 

        if sorted_quotes.count > 10
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