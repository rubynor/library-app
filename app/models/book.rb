class Book < ApplicationRecord
  belongs_to :user

  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :title, :author, :description, presence: true

  has_many :bookmarked_by, through: :bookmarks, source: :user

  def bookmarked_by?(current_user)
    bookmarks.exists?(user: current_user)
  end
end
