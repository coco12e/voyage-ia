Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :trips, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  resources :conversations, only: [:index, :show, :destroy] do
    resources :messages, only: [:create]
  end
end
