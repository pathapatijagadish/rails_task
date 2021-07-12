Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :events
      get 'repos/:id/events', to: 'events#repository_events'
      resources :users, only: [:index]
      resources :repositories, only: [:index]
    end
  end
end
