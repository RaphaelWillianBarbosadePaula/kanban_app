class User < ApplicationRecord
  has_secure_password

  has_many :created_projects, class_name: "Project", foreign_key: "created_by_id"
  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, length: { maximum: 150 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
end
