Rails.application.routes.draw do
  resources :applications, param: :token, only: [:index, :show, :create, :update, :destroy] do
      resources :chats, param: :number, only: [:index, :show, :create, :update, :destroy] do
        resources :messages, param: :number, only: [:index, :show, :create, :update, :destroy]
      end
  end
end
