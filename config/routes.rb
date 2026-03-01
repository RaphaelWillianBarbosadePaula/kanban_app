require "sidekiq/web"

Rails.application.routes.draw do
  resources :users

  get "/signup", to: "users#new", as: :signup
  get "/login", to: "authentication#new", as: :login
  post "/login", to: "authentication#login"
  delete "/logout", to: "authentication#logout", as: :logout

  root "home#index"
  mount Sidekiq::Web => "/sidekiq"
end
