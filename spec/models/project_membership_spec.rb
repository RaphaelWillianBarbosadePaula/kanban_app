require 'rails_helper'

RSpec.describe ProjectMembership, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:role).in_array(%w[owner admin member]) }

    subject { build(:project_membership) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:project_id) }
  end
end
