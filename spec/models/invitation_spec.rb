require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:sender).class_name('User') }
  end

  describe 'validations' do
    subject { build(:invitation) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('user@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid').for(:email) }
  end

  describe '#expired?' do
    let(:invitation) { build(:invitation, expires_at: 1.day.ago) }

    it 'retorna true se a data passou' do
      expect(invitation.expired?).to be true
    end

    it 'retorna false se ainda está no prazo' do
      invitation.expires_at = 1.day.from_now
      expect(invitation.expired?).to be false
    end
  end
end