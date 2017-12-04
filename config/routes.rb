Rails.application.routes.draw do
  devise_for :users
  resources :films
  resources :ratings
  post 'recommend_film', to: 'films#recommend_film', as: 'recommend_film'

  root 'films#index'
end
