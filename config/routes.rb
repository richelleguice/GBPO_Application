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
  

  # cart/view, cart/checkout, cart/:id/addItem, cart/:id/removeItem, cart/emptyCart
  get 'cart/show', to: 'cart#show', as: :view_cart
  get 'cart/checkout', to: 'cart#checkout', as: :checkout
  get 'cart/:id/add_item', to: 'cart#add_item', as: :add_item
  get 'cart/:id/remove_item', to: 'cart#remove_item', as: :remove_item
  get 'cart/empty_cart', to: 'cart#empty_cart', as: :empty_cart
  
  get 'item_prices/new', to: 'item_prices#new', as: :new_item_price
  post 'item_prices/create', to: 'item_prices#create', as: :item_prices


  patch 'items/:id/toggle_active', to: 'items#toggle_active', as: :toggle_active
  patch 'items/:id/toggle_feature', to: 'items#toggle_feature', as: :toggle_feature

  patch 'cart/checkout', to: 'cart#checkout', as: :order_checkout

  get 'search', to: 'search#search', as: :search


end
