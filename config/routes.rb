Rails.application.routes.draw do
  resources :markets, only: [:index, :show]
  resources :vendors, only: [:show] do
    get 'search_markets', on: :member
    post 'add_market', on: :member
  end
end
