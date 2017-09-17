defmodule KhcplWeb.EventsController do
  use KhcplWeb, :controller

  alias Khcpl.Event
  alias Khcpl.Band
  alias Khcpl.Repo

  def index(conn, _params) do
    render conn, "index.html", events: Repo.all(Event), bands: Repo.all(Band)
  end
end
