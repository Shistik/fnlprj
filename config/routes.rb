Rails.application.routes.draw do
  root to: 'lab#input'
  get 'lab/input'
  get 'lab/output'
  get 'sessions/login'

  post 'sessions/create'

  get 'sessions/logout'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
