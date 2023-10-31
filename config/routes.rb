Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, skip: [:registrations]
  root 'home#index'
  get '/bebes', to: 'bebes#index'
  post 'bebes', to: 'bebes#create'

  post '/votacion', to: 'votaciones#votar', as: 'votar'
  get '/votacion', to: 'votaciones#mostrar_duelo', as: 'votacions'
  delete '/votacion', to: 'votaciones#reiniciar_votos', as: 'reiniciar_votos'

  post '/generar_cuadros', to: 'competition#generar_cuadros', as: 'crear_cuadro'
  get '/cuadro_masculino', to: 'competition#competicion_masculina', as: 'cuadro_masculino'
  get '/cuadro_femenino', to: 'competition#competicion_femenina', as: 'cuadro_femenino'
  get '/ganador_masculino', to: 'competition#ganador_masculino', as: 'ganador_masculino'
  get '/ganador_femenino', to: 'competition#ganador_femenino', as: 'ganador_femenino'
  post '/competition_vote', to: 'competition_votes#create', as: 'competition_vote'
  delete '/competition_vote', to: 'competition_votes#delete', as: 'competition_vote_delete'
end
