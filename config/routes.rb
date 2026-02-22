require "sidekiq/web"

Rails.application.routes.draw do
  resources :users

  post "/login", to: "authentication#login", as: :login
  delete "/logout", to: "authentication#logout", as: :logout

  root "home#index"
  mount Sidekiq::Web => "/sidekiq"
end
