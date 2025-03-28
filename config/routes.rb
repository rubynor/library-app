Rails.application.routes.draw do
  devise_for :users
  
  get 'books/index'
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Root route
  root 'books#index'
  
  # Books routes
  resources :books do
    # Nested bookmark routes
    resource :bookmarks, only: [:create, :destroy]

    member do
      get 'download'
    end

    # Define the 'details' route
    get 'details', on: :member
  end
  
  # Reviews routes
  resources :reviews, only: [:create]
end
