Rails.application.routes.draw do
  localized do#gem see late
    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  root to: 'lab#input'
  get 'lab/input'
  get 'lab/output'
    end
    end
  get 'sessions/login'

  post 'sessions/create'

  get 'sessions/logout'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
