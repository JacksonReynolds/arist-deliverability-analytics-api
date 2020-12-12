Rails.application.routes.draw do
  namespace :api do
    get '/test', to: 'analytics#test'
  end
end
