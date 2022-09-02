Rails.application.routes.draw do
  resources :transaction_imports, only: [:new, :create]
  
  resources :transactions
  resources :categories
  devise_for :users
end
