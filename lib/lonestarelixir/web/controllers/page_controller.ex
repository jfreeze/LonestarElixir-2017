defmodule Lonestarelixir.Web.PageController do
  use Lonestarelixir.Web, :controller

  plug :put_layout, "lonestar.html"

  def index(conn, _params) do
    render conn, "index.html"
  end

  def coc(conn, _params) do
    render conn, "coc.html"
  end

  def speakers(conn, _params) do
    render conn, "speakers.html"
  end
end
