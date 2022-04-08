Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "sessions#launch"

  post "upload-quotes/:id", to: "quotes#upload_quotes"

  post "admins/login", to: "sessions#admin_login"
  post "admins/:admin_id/create", to: "admins#create"

  get 'quotes', to: "quotes#index"

  delete 'quotes/:username', to: "quotes#destroy"

  resources :users, only: [:create]

  post 'users/login', to: "sessions#login"

  get 'quotes/of-the-day', to: "quotes#daily_quote"

end
