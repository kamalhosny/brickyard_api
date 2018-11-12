Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: :create
  resources :users, only: :show do
    resources :vehicles
  end
  resources :states
end
