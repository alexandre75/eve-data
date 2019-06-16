Rails.application.routes.draw do
  get 'histories/index'
  get 'histories/get'
  get 'traders/index'
  get 'trades/index'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :regions do
    resource :book, :only => [:show]
    resources :stations do
      resource :book, :only => [:show]
    end
    resources :histories, :only => [:show]
  end
  root 'welcome#index'
end
