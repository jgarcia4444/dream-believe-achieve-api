class User < ApplicationRecord
    has_secure_password

    has_one :notification_quote, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :daily_quotes, dependent: :destroy

    validates :email, uniqueness: true
    validates :email, presence: true
    validates :username, uniqueness: true
    validates :username, presence: true
    validates :password, presence: true
    

end