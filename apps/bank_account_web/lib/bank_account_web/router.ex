defmodule BankAccountWeb.Router do
  use BankAccountWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_jwt_auth do
    plug BankAccountWeb.Auth.Pipeline
  end

  scope "/api", BankAccountWeb do
    pipe_through :api

    post "/sign_up", UserController, :sign_up
    post "/sign_in", UserController, :sign_in
  end

  scope "/api", BankAccountWeb do
    pipe_through [:api, :ensure_jwt_auth]

    post "/account", AccountController, :create_or_update
    get "/account/indications/:referral_code", AccountController, :list_indications
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BankAccountWeb.Telemetry
    end
  end
end
