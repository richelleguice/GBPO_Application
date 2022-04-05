Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # Only need two routes for the API
      get 'orders', to: 'orders#index'
      get 'customers/:id', to: 'customers#show'
    end
  end

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # Authentication routes
  resources :sessions
  resources :users, only: [:edit, :update, :create, :update, :new, :index]
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes
  resources :customers
  resources :addresses
  resources :categories, except: [:show, :destroy]
  resources :items
  resources :orders
  
  get 'item_prices/new', to: 'item_prices#new', as: :new_item_price
  post 'item_prices/create', to: 'item_prices#create', as: :item_prices


  patch 'items/:id/toggle_active', to: 'items#toggle_active', as: :toggle_active
  patch 'items/:id/toggle_feature', to: 'items#toggle_feature', as: :toggle_feature

  patch 'cart/checkout', to: 'cart#checkout', as: :checkout



end
