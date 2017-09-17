defmodule KhcplWeb.Router do
  use KhcplWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KhcplWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/events", EventsController, :index
  end

  forward "/graphql", Absinthe.Plug,
    schema: Khcpl.Schema

  # Other scopes may use custom stacks.
  # scope "/api", KhcplWeb do
  #   pipe_through :api
  # end
end
