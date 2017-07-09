Rails.application.routes.draw do
  devise_for :clients
 root :to => 'home#index'
match "home/data", :to => "home#data", :as => "data", :via => "get"
match "home/db_action", :to => "home#db_action", :as => "db_action", :via => "get"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
