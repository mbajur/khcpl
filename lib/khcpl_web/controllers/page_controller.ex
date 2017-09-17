defmodule KhcplWeb.PageController do
  use KhcplWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
