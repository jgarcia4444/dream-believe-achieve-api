
class DailyQuote < ApplicationRecord 
    belongs_to :user
    has_one :quote
end