class Chat < ApplicationRecord
  belongs_to :application, touch: true, counter_cache: :chats_count

  has_many :messages, dependent: :destroy

  validates :number, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :application, message: "No two chats within the same application can have the same number."}
end
