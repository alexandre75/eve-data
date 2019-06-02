Rails.application.routes.draw do
  get 'traders/index'
  get 'trades/index'
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :regions do
    resources :stations do
      resources :books
    end
  end
  resources :traders
  root 'welcome#index'
end
