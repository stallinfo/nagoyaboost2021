Rails.application.routes.draw do

  resources :products
  devise_scope :user do 
    get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # sign_up/registration
    get "sign_out", :to => "users/sessions#destroy" 
  end

  devise_for :users

  get 'landings/Home'
  get '/showmap', to: 'landings#ShowMap'
  root 'landings#Home'
  
  resources :sales_points
  post '/add_sales_product_relation',  to: 'sales_points#add_sales_product_relation'
  post '/edit_sales_product_relation', to: 'sales_points#edit_sales_product_relation'
  delete '/delete_sales_product_relation', to: 'sales_points#delete_sales_product_relation'
end
