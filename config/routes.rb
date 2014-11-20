Rails.application.routes.draw do
  root to: 'home#index'

  resources :todos do
    collection do
      post :clear_completed
    end

    member do
      post :complete
      post :incomplete
    end
  end
end
