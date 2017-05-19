Rails.application.routes.draw do
  root 'welcome#index'
  resources :notices
  
  get 'sessions/new'

  resources :ledgers
  resources :stocks
  resources :users
  get '/login'  ,   to: 'sessions#new'
  post '/login'  ,  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'my_portfolio', to: "users#my_portfolio"
  get 'search_stocks', to: "stocks#search"
end
