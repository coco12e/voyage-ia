Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :trips do
    resources :conversations, only: %i[create show]
  end
end
