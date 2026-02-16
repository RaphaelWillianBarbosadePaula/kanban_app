class User < ApplicationRecord
    has_secure_password

    normalizes :email, with: ->(e) {e.strip.downcase}

    validates :name, presence: true, length: {maximum: 150}
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
end
