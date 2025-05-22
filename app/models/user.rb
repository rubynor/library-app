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
    allowed_domains = ["rubynor.com", "fasttravel.com", "kraftanmelding.no", "kaiasolutions.no", "swiftner.com"]
    domain = email.split("@").last
    unless allowed_domains.include?(domain)
      errors.add(:email, "must be from one of the following domains: #{allowed_domains.join(', ')}")
    end
  end
end
