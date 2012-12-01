RedditRss::Application.routes.draw do
  resources :images
  root :to => 'images#latest'
end
