Rails.application.routes.draw do
  root to: "homepages#index"
  resources :passengers
  resources :drivers
  resources :trips

  resources :passengers do
    resources :trips, only: [:index, :new]
  end

  resources :drivers do
    resources :trips, only: [:index, :new]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
