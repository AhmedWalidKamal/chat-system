class Chat < ApplicationRecord
  belongs_to :application

  has_many :messages, dependent: :destroy

  validates :number, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :application, message: "No two messages within the same application can have the same number."}
end
