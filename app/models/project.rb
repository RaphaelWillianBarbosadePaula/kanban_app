class Project < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships

  validates :name, presence: true
end
