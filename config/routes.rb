Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'shozokus#index'
  resources :shozokus, only: [:index, :create, :update, :destroy]
  resources :yakushokus, only: [:index, :create, :update, :destroy]
end
