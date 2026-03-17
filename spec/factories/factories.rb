FactoryBot.define do
  factory :user do
    name  { 'Usuário Teste' }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :blacklisted_token do
    token { "TOKEN123456" }
    expire_at { "2026-02-22 15:33:41" }
  end

  factory :project do
    name { "Meu Projeto Kanban" }
    description { "Descrição do projeto" }
    association :creator, factory: :user
  end

  factory :project_membership do
    association :user
    association :project
    role { "member" }
  end

  factory :invitation do
    email {  Faker::Internet.unique.email }
    association :project
    association :sender, factory: :user
    status { "pending" }
  end
end
