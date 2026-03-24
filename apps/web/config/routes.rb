Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "health" => "health#show"
  post "sessions" => "sessions#create"
  post "charges" => "charges#create"
end
