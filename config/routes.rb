Rails.application.routes.draw do
  root to: "root#index"

  scope "api", defaults: {format: :json} do
    scope "v1" do
      resources :weather, only: [:index] do
        post :create_notes, on: :collection
        get :caches, on: :collection
      end
    end
  end
end
