Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, skip: [:registrations]
  root 'home#index'
  get '/bebes', to: 'bebes#index'
  post 'bebes', to: 'bebes#create'

  post '/votacion', to: 'votaciones#votar', as: 'votar'
  get '/votacion', to: 'votaciones#mostrar_duelo', as: 'votacions'
  delete '/votacion', to: 'votaciones#reiniciar_votos', as: 'reiniciar_votos'
end
