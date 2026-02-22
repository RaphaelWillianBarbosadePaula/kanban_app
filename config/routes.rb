require "sidekiq/web"

Rails.application.routes.draw do
  resources :users

  post "/auth/login", to: "authentication#login"

  root "home#index"
  mount Sidekiq::Web => "/sidekiq"
end
