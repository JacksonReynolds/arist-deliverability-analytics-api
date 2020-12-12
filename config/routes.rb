Rails.application.routes.draw do
  namespace :api do
    get '/test', to: 'analytics#test'
    post '/register', to: 'analytics#register'
    post '/alive', to: 'analytics#alive'
    post '/report', to: 'analytics#report'
    patch '/terminate', to: 'analytics#terminate'
  end
end
