Rails.application.routes.draw do
  get 'communion/index'
  get 'communion/generate'

  root 'communion#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
