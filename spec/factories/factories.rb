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
end
