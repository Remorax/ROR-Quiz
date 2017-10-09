Rails.application.routes.draw do

  resources :problems
  resources :subgenres
  get '/subgenres/new/:genre_id' => 'subgenres#new'
  post '/subgenres/create/:genre_id' => 'subgenres#create'
  resources :genres
  get '/genres/new' => 'genres#new'
  post '/genres/create' => 'genres#create'	

  get '/users/login' => 'sessions#new'
  get '/users/leaderboard/' => 'users#leaderboard'
  get '/users/leaderboard/:problem_id' => 'users#leaderboard'
  post '/users/login' => 'sessions#create'
  post '/' => 'sessions#create'
  get '/users/logout' => 'sessions#destroy'

  get '/admins/login' => 'sessions_admin#new'
  post '/admins/login' => 'sessions_admin#create'
  get '/admins/logout' => 'sessions_admin#destroy'

  get 'admin/index'

  get "/users/welcome/:id" => 'users#welcome'

  get "/admins/welcome/:id" => 'admins#welcome'

  get "/users/login" => 'sessions#new'

  get "/admins/login" => 'sessions_admin#new'
  root :to => "sessions#new"

  resources :admins
  get 'sessions/new'
  get 'sessions/create'

  get 'sessions/destroy'

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
