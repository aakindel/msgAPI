Rails.application.routes.draw do
  root to: 'messages#index'
  
  resources :messages, except: [:edit]

  get '/messages/:id/edit', to: 'messages#edit', as: 'edit'

end
