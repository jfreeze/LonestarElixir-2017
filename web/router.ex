defmodule Lonestarelixir.Router do
  use Lonestarelixir.Web, :router

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

  scope "/", Lonestarelixir do
    pipe_through :browser # Use the default browser stack

    get "/test", PageController, :test
    get "/coc", PageController, :coc
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lonestarelixir do
  #   pipe_through :api
  # end
end