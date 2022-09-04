Rails.application.routes.draw do
  resources :transaction_imports, only: [:new, :create]
  
  resources :transactions, only: [:index, :show, :edit, :update]
  resources :categories
  devise_for :users

  root "transactions#index"
end
