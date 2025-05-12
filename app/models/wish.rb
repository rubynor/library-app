class Wish < ApplicationRecord
  belongs_to :user
  has_one_attached :cover_image

  validate :cover_image_presence

  private

  def cover_image_presence
    errors.add(:cover_image, "must be attached") unless cover_image.attached?
  end
end
