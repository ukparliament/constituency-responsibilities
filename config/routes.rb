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

  get 'constituencies/:constituency/responsibilities' => 'constituency_responsibility#index', as: :constituency_responsibility_list
  
  get 'constituencies/:constituency/overlaps' => 'constituency_overlap#index', as: :constituency_overlap_list
  
  get 'responsibilities' => 'responsibility#index', as: :responsibility_list
  get 'responsibilities/:responsibility' => 'responsibility#show', as: :responsibility_show
  
  get 'organisation-types' => 'organisation_type#index', as: :organisation_type_list
  get 'organisation-types/:organisation_type' => 'organisation_type#show', as: :organisation_type_show
  
  get 'organisations' => 'organisation#index', as: :organisation_list
  get 'organisations/:organisation' => 'organisation#show', as: :organisation_show

  get 'organisations/:organisation/responsibilities' => 'organisation_responsibility#index', as: :organisation_responsibility_list
    
  get 'organisations/:organisation/overlaps' => 'organisation_overlap#index', as: :organisation_overlap_list
    
  get 'organisations/:organisation/subsidiaries' => 'organisation_subsidiary#index', as: :organisation_subsidiary_list
    
  get 'organisations/:organisation/types' => 'organisation_having_type#index', as: :organisation_having_type_list
  
  get 'procedure-browser/meta' => 'meta#index', as: :meta_list
  get 'procedure-browser/meta/cookies' => 'meta#cookies', as: :meta_cookies
end
