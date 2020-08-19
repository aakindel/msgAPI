Rails.application.routes.draw do
  root to: 'messages#index'
  
  resources :messages, except: [:edit, :destroy]

  get '/messages/:id/edit', to: 'messages#edit', as: 'edit'
  delete '/messages/:id', to: 'messages#destroy', as: 'destroy'

end
