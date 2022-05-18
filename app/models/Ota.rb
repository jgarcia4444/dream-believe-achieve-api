class Ota < ApplicationRecord

    belongs_to :user
    validates :code, presence: true
    validates :user_id, presence: true
    validates :code, length: { is: 6 }

end