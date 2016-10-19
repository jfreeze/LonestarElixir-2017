defmodule Lonestarelixir.PageController do
  use Lonestarelixir.Web, :controller

  plug :put_layout, "lonestar.html"

  def index(conn, _params) do
    render conn, "index.html"
    #redirect conn, to: "/index.html"
    #redirect conn, to: "/css/app.css"
  end

  def test(conn, _params) do
    #redirect conn, to: "/test.html"
    render conn, "test.html"
  end

  def coc(conn, _params) do
    render conn, "coc.html"
  end
end
