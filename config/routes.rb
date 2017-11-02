Rails.application.routes.draw do
  get 'cases', to: 'cases#index', defaults: { format: 'json' }
end
