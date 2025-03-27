class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, uniqueness: { scope: :book_id, message: "You have already bookmarked this book" }
end