Rails.application.routes.draw do
  get 'communion/index'

  resources :lineups

  root 'communion#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
