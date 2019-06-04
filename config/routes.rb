Rails.application.routes.draw do
  get 'histories/index'
  get 'histories/get'
  get 'traders/index'
  get 'trades/index'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :regions do
    resources :stations do
      resources :books
    end
    resources :histories
  end
  resources :traders
  root 'welcome#index'
end
