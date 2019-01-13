Rails.application.routes.draw do

  root 'users#welcome'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get 'auth/:provider/callback' => 'sessions#create'

  get '/recipes/:id/next' => 'recipes#next'
  get '/your_recipes' => 'recipes#your_recipes'
  get '/search' => 'recipes#search'
  get 'recipes_find_newest' => 'recipes#find_newest'
  get 'recipes_find_quickest' => 'recipes#find_quickest'
  get 'recipes_most_ingredients' => 'recipes#most_ingredients'
  get '/ajax_new' => 'comments#ajax_new'


  resources :users
  resources :ingredients

  resources :recipes do
    resources :comments, only: [:show, :index, :new, :edit, :create]
  end
  resources :comments, only: [:index, :show, :new, :edit, :update, :destroy]
end


