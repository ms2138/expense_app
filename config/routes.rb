Rails.application.routes.draw do
  get 'transaction_imports/new'
  
  resources :transactions
  resources :categories
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
