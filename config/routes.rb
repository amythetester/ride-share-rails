Rails.application.routes.draw do
  root to: "homepages#index"
  resources :passengers
  resources :drivers

  resources :passengers do
    resources :trips, except: [:index, :new]
  end

  resources :drivers do
    resources :trips, except: [:index, :new]
  end
end
