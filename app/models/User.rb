class User < ApplicationRecord
    has_secure_password

    has_one :notification_quote
    has_many :favorites

    validates :email, uniqueness: true
    validates :email, presence: true
    validates :username, uniqueness: true
    validates :username, presence: true
    validates :password, presence: true
    

end