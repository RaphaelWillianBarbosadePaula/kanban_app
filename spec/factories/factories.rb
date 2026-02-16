FactoryBot.define do
  factory :user do
    name  { 'Usuário Teste' }
    email { Faker::Internet.unique.email }
    password { 'password123' }
  end
end
