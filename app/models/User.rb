class User < ApplicationRecord
    has_secure_password

    has_one :notification_quote, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :daily_quotes, dependent: :destroy

    validates :email, uniqueness: true
    validates :email, presence: true
    validates :username, uniqueness: true
    validates :username, presence: true

    def add_quote_to_daily_quotes(quote)
        new_daily_quote = DailyQuote.create(quote_id: quote.id, user_id: self.id)
        if !new_daily_quote
            render :json => {
                error: {
                    hasError: true,
                    message: "There was an error logging this quote to your account"
                }
            }
        end
    end

    def favorite_quotes
        self.favorites.map do |favorite|
            quote = Quote.find_by(id: favorite.quote_id)
            favorites_count = quote.favorites.count
            if quote
                {
                    id: quote.id,
                    author: quote.author,
                    quote: quote.quote,
                    favorites: favorites_count
                }
            else
                render :json => {
                    error: {
                        hasError: true,
                        message: "There was an error finding a favorite quote."
                    }
                }
            end
        end
    end
    

end