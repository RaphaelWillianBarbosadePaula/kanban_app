require 'rails_helper'

RSpec.describe BlacklistedToken, type: :model do
  describe 'validations' do
    subject {
      BlacklistedToken.new(
        token: 'jwt_token123456',
        expire_at: 24.hours.from_now
      )
    }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a token' do
      subject.token = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an expire_at' do
      subject.expire_at = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate token' do
      BlacklistedToken.create!(
        token: 'token_repetido',
        expire_at: 1.hour.from_now
      )

      duplicate = BlacklistedToken.new(
        token: 'token_repetido',
        expire_at: 2.hours.from_now
      )

      expect(duplicate).to_not be_valid
    end
  end
end
