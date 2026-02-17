require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    it 'creates a valid user' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it 'is invalid when name is longer than 150 characters' do
      user = build(:user, name: 'a' * 151)
      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with duplicated email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')

      expect(user).not_to be_valid
    end

    it 'is invalid with an invalid email format' do
      user = build(:user, email: 'email_invalido')
      expect(user).not_to be_valid
    end

    it 'is invalid without password' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid with password shorter than 8 characters' do
      user = build(:user, password: '1234567', password_confirmation: '1234567')
      expect(user).not_to be_valid
    end
  end

  describe 'has_secure_password' do
    it 'authenticates with correct password' do
      user = create(:user, password: 'password123')

      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with wrong password' do
      user = create(:user, password: 'password123')

      expect(user.authenticate('wrongpass')).to be_falsey
    end
  end

  describe 'normalizations' do
    it 'normalizes email before validation' do
      user = create(:user, email: '  TEST@Email.COM ')

      expect(user.email).to eq('test@email.com')
    end
  end
end
