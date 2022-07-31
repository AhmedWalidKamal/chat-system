class Message < ApplicationRecord
  belongs_to :chat, touch: true, counter_cache: :messages_count

  validates :number, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :chat, message: "No two messages within the same chat can have the same number."}
end
