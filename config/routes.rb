Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get '/home', to: 'welcome#index', as: 'index'
  get '/about', to: 'welcome#about'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :articles do
    resources :comments # nested routing
  end

  resources :account_activations, only: [:edit]

  resources :users
  root 'welcome#index'
end
