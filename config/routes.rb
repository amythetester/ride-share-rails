Rails.application.routes.draw do
  root to: "homepages#index"
  resources :passengers
  resources :drivers
  resources :trips

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
