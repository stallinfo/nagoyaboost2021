Rails.application.routes.draw do
  get 'landings/Home'
  get '/showmap', to: 'landings#ShowMap'
  root 'landings#Home'

end
