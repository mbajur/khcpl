defmodule Khcpl.Album do
  use Ecto.Schema
  import Ecto.Changeset
  alias Khcpl.Album


  schema "albums" do
    field :name, :string
    field :url, :string
    field :band_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Album{} = album, attrs) do
    album
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
  end
end
