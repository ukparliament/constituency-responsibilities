Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  
  mount LibraryDesign::Engine => "/library_design"

  # Defines the root path route ("/")
  root 'home#index', as: :root
  
  get 'constituency-responsibilities' => 'home#index', as: :home
  
  get 'constituencies/countries' => 'constituency_country#index', as: :constituency_country_list
  get 'constituencies/countries/:country' => 'constituency_country#show', as: :constituency_country_show
  
  get 'constituencies/countries/:country/regions' => 'constituency_region#index', as: :constituency_region_list
  get 'constituencies/countries/:country/regions/:region' => 'constituency_region#show', as: :constituency_region_show
  
  get 'constituencies' => 'constituency#index', as: :constituency_list
  get 'constituencies/:constituency' => 'constituency#show', as: :constituency_show
  
  get 'organisation-types' => 'organisation_type#index', as: :organisation_type_list
  get 'organisation-types/:organisation_type' => 'organisation_type#show', as: :organisation_type_show
  
  get 'organisations' => 'organisation#index', as: :organisation_list
  get 'organisations/:organisation' => 'organisation#show', as: :organisation_show
  
  get 'procedure-browser/meta/cookies' => 'meta#cookies', as: :meta_cookies
end
