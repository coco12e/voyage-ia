Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :trips do
    resources :conversations, only: %i[create show]
    resources :chats, only: [:create]
  end

  resources :chats, only: [:show, :destroy] do
    resources :messages, only: [:create]
  end
end
