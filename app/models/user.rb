class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :confirmable

  has_many :books, dependent: :destroy  # Users upload books
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validate :email_domain_check
  after_create :log_confirmation_details
  
  private
  
  def log_confirmation_details
    Rails.logger.debug "User created with email: #{self.email}"
    Rails.logger.debug "Confirmation token: #{self.confirmation_token}"
    Rails.logger.debug "Confirmation sent at: #{self.confirmation_sent_at}"
  end

  def email_domain_check
    allowed_domain = "rubynor.com"
    unless email.ends_with?("@#{allowed_domain}")
      errors.add(:email, "must be a rubynor.com address")
    end
  end
end
