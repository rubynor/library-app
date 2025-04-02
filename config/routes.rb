Rails.application.routes.draw do
  devise_for :users
  
  get 'books/index'
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  root 'books#index'
  
  resources :books do
    resource :bookmarks, only: [:create, :destroy]

    member do
      get :details
      get :download
      get :user_review
    end

    get 'details', on: :member
  end
  
  resources :reviews, only: [:create]
end
