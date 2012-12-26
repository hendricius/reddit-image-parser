RedditRss::Application.routes.draw do
  root :to => 'images#latest'
  resources :users, only: [:new, :create] do
    resources :images, :shallow => true, only: [:index, :show] do
      member do
        post "favorite"
        post "unfavorite"
      end
    end
    resources :favorites, only: [:index]
  end
  get 'users/:user_id/images/:image_id' => 'images#user_image', as: "user_image_collection"
  get "top_users" => "images#top_users", as: "top_users"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  resources :sessions
end
