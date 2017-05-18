Rails.application.routes.draw do
  resources :ledgers
  resources :stocks
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
