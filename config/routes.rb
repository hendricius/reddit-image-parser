RedditRss::Application.routes.draw do
  root :to => 'images#latest'
  resources :users, only: [] do
    resources :images, :shallow => true, only: [:index, :show]
  end
  get 'users/:user_id/images/:image_id' => 'images#user_image', as: "user_image_collection"
  get "top_users" => "images#top_users", as: "top_users"
end
