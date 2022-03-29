Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # Only need two routes for the API
      get 'orders', to: 'orders#index'
      get 'customers/:id', to: 'customers#show'
    end
  end

  

end
