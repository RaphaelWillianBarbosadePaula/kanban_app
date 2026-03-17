class Invitation < ApplicationRecord
  belongs_to :project
  belongs_to :sender, class_name: "User"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  def expired?
    status == "expired" || expires_at < Time.current
  end

  private

  def generate_token
    self.token = SecureRandom.hex(32) if token.blank?
  end

  def set_expiration
    self.expires_at = 7.days.from_now if expires_at.blank?
  end
end
