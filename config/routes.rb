Rails.application.routes.draw do
  devise_for :users

  resources :transaction_imports, only: [:new, :create]
  resources :transactions, only: [:index, :show, :edit, :update]
  
  resources :users, only: [:show], shallow: true do
    resources :categories
  end

  root "transactions#index"
end
