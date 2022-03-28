class Admin < ApplicationRecord
    validates :username, presence: true
end