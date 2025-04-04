class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy  # Users upload books
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validate :email_domain_check

  private

  def email_domain_check
    allowed_domain = "rubynor.com"
    unless email.ends_with?("@#{allowed_domain}")
      errors.add(:email, "must be a rubynor.com address")
    end
  end
end
