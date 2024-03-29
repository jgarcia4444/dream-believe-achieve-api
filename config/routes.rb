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

  post 'quotes/get-daily-quote', to: "quotes#daily_quote"

  get "users/:username/favorites", to: "users#favorites"
  post "users/:username/favorites/add", to: "favorites#add"
  delete "users/:username/favorites/remove", to: "favorites#remove"

  get "top-ten-quotes", to: "quotes#get_top_ten_quotes"

  post 'users/send-code', to: "users#send_code"
  post 'users/change-password', to: "users#change_password"

end
