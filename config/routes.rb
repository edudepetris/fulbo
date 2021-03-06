Fulbo::Application.routes.draw do

  root :to => "landing_page#index"

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :leagues do
    resources :affiliations, only: [:create, :destroy]
    resource :fixture do
      get 'page/:page', action: :show, on: :collection
    end
  end

  resources :teams do
    resources :photos
    resources :request_inscriptions, only: [:create]
  end

  resources :sport_centers do
    resources :locations
    resources :leagues, controller: 'sport_center_leagues'
  end

  resources :profiles, only:[:index], controller: 'user_profile'

  resources :users, only:[:index]

  resources :fields do
    resources :reservations, only: [:create]
  end

  resources :fields, only:[:index]

  resources :locations do
    resources :fields
  end

  resources :matches do
    resources :goals, only: [:create, :destroy, :new]
  end

  devise_for :users,  :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, :path => "" do
    resource :profile, only: [:show, :edit, :update], controller: 'UserProfile'
  end

  get   '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'
  match '/users/auth/facebook' => 'users/omniauth_callbacks#passthru'


 devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
 end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
