RedditRss::Application.routes.draw do
  root :to => 'images#latest'
  resources :users do
    resources :images, :shallow => true
  end
  get 'users/:user_id/images/:image_id' => 'images#user_image', as: "user_image_collection"
end
