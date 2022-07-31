class Application < ApplicationRecord
    has_secure_token

    has_many :chats, dependent: :destroy

    validates :name, presence: true, length: { in: 3..40 }
end
