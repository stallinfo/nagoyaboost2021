Rails.application.routes.draw do
  
  

  devise_scope :user do 
    get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # sign_up/registration
    get "sign_out", :to => "users/sessions#destroy" 
  end

  devise_for :users

  get 'landings/Home'
  get '/showmap', to: 'landings#ShowMap'
  root 'landings#Home'

end
