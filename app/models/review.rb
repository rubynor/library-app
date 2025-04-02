class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, presence: true
  validates :user_id, uniqueness: { scope: :book_id, message: "You've already reviewed this book" }
end