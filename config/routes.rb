Rails.application.routes.draw do
    get '/books/:id' => 'books#show'
    delete '/books/:id' => 'books#destroy'
    resources :publishers
    resource :profile, only: [:show, :edit, :update]
end
