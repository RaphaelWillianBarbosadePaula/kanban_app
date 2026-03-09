require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:creator).class_name('User').with_foreign_key('created_by_id') }
    it { is_expected.to have_many(:project_memberships).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:project_memberships) }
  end

  describe 'validations' do
    subject { build(:project) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
