defmodule Auth1Web.Router do
  use Auth1Web, :router

  import Auth1Web.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Auth1Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Auth1Web do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Auth1Web do
  #   pipe_through :api
  # end

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Auth1Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", Auth1Web do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users1/register", UserRegistrationController, :new
    post "/users1/register", UserRegistrationController, :create
    get "/users1/log_in", UserSessionController, :new
    post "/users1/log_in", UserSessionController, :create
    get "/users1/reset_password", UserResetPasswordController, :new
    post "/users1/reset_password", UserResetPasswordController, :create
    get "/users1/reset_password/:token", UserResetPasswordController, :edit
    put "/users1/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", Auth1Web do
    pipe_through [:browser, :require_authenticated_user]

    get "/users1/settings", UserSettingsController, :edit
    put "/users1/settings", UserSettingsController, :update
    get "/users1/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", Auth1Web do
    pipe_through [:browser]

    delete "/users1/log_out", UserSessionController, :delete
    get "/users1/confirm", UserConfirmationController, :new
    post "/users1/confirm", UserConfirmationController, :create
    get "/users1/confirm/:token", UserConfirmationController, :edit
    post "/users1/confirm/:token", UserConfirmationController, :update
  end
end
