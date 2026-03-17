require "sidekiq/web"

Rails.application.routes.draw do
  resources :users
  resources :projects do
    get "index_members", on: :member
  end
  resources :invitations do
    get "accept_invitation", on: :collection, as: :accept
  end

  get "/signup", to: "users#new", as: :signup
  get "/login", to: "authentication#new", as: :login
  post "/login", to: "authentication#login"
  delete "/logout", to: "authentication#logout", as: :logout

  root "home#index"
  mount Sidekiq::Web => "/sidekiq"
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
