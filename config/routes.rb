Rails.application.routes.draw do
  devise_for :users
  
  get 'books/index'
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Root route
  root 'book#index'
  
  # Books routes
  resources :book do
    # Nested bookmark routes
    resource :bookmarks, only: [:create, :destroy]
  end
  
  # Reviews routes
  resources :reviews, only: [:create]
end