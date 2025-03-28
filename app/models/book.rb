class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  
  has_one_attached :pdf_file

  validates :title, :author, :description, presence: true
  has_many :bookmarked_by, through: :bookmarks, source: :user

  has_one_attached :cover_image
  validates :cover_image, presence: true

  
  def pdf_available?
    pdf_file.attached?
  end

  def bookmarked_by?(current_user)
    bookmarks.exists?(user: current_user)
  end

  def pdf_url
    pdf_file.attached? ? Rails.application.routes.url_helpers.rails_blob_path(pdf_file, disposition: "attachment") : nil
  end
end