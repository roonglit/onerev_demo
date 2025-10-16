Rails.application.routes.draw do
  get "post/new"
  resources :homes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  mount Lms::Engine => "/lms"
  mount Campfire::Engine => "/chat"

  namespace "admin" do
    mount Lms::Engine => "/lms"

    root to: redirect("/admin/lms/courses")
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  post "/call_api_get_keycloak_token", to: "apis#call_api_get_keycloak_token", as: :call_api_get_keycloak_token
  post "/create_teams_event", to: "apis#create_teams_event", as: :create_teams_event
  delete "/clear_token", to: "apis#clear_token", as: :clear_token

  root to: "home#index"
end
