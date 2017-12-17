Rails.application.routes.draw do
  devise_for :users
  resources :films, only: [:index, :show]
  resources :ratings, only: [:create, :update]
  get 'recommend_film', to: 'films#recommend_film', as: 'recommend_film'
  get 'top', to: 'films#top', as: 'top'

  root 'films#index'
end
