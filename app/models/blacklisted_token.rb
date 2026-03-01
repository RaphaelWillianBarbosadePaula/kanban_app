class BlacklistedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :expire_at, presence: true
end
