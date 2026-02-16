require "sidekiq/web"

Rails.application.routes.draw do
  resources :users

  root "home#index"

  # Painel do Sidekiq
  mount Sidekiq::Web => "/sidekiq"
end
