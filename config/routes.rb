Rails.application.routes.draw do
  get 'users/show'
  devise_for :users

  resources :transaction_imports, only: [:new, :create]
  resources :transactions, only: [:index, :show, :edit, :update] do
    collection do
      delete 'destroy_multiple'
    end
  end
  
  resources :users, only: [:show], shallow: true do
    resources :categories do
      collection do
        delete 'destroy_multiple'
      end
    end
  end

  root "transactions#index"
end
