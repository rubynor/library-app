class Book < ApplicationRecord
  belongs_to :user

  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :title, :author, :description, presence: true
end
