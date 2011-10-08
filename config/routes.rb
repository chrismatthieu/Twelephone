Gospelr3::Application.routes.draw do


  match 'verses/highlight' => 'verses#highlight'
  match 'comments/create' => 'comments#create'

  # Omniauth pure
  match "/signin" => "sessions#signin"
  match "/signout" => "sessions#signout"

  match '/auth/:service/callback' => 'sessions#create' 
  match '/auth/failure' => 'sessions#failure'
  match '/auth/:provider' => "application#omniauth"
  match '/users/password' => "users#password"
  match '/feed' => "users#feed"
  match '/tweetverse' => "static#tweetverse"

  
  resources :users
  resources :verses
  resources :bibles
  resources :sessions
  # resources :comments
  
  resources :comments do
    collection do
      put :update_attribute_on_the_spot_in_tree
    end
  end  
  resources :follows

  match ':user/following' => 'follows#index', :view => 'following'
  match ':user/followers' => 'follows#index', :view => 'followers'

  match 'search/:id' => 'verses#search'
  match 'search' => 'verses#search'
  match 'jump/:id' => 'verses#jump'
  match 'jump' => 'verses#jump'

  match '/login' => 'sessions#new'
  match '/logout' => 'sessions#destroy'
  match '/password/:id' => 'users#password'
  match '/about' => 'static#about'

  match ':book/:chapter' => 'verses#jump' #, :constraints => {:book => /!(auth)/}
  match ':book/:chapter/:verse' => 'verses#jump'
  
  match ':user' => 'users#show'



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
  root :to => 'static#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
