Rails.application.routes.draw do
  devise_for :users
  resources :films
  resources :ratings
  get 'recommend_film', to: 'films#recommend_film', as: 'recommend_film'
  get 'top', to: 'films#top', as: 'top'

  root 'films#index'
end
