defmodule Khcpl.Band do
  use Ecto.Schema
  import Ecto.Changeset
  alias Khcpl.Band


  schema "bands" do
    field :name, :string
    field :url, :string
    field :location, :string
    field :photo_url, :string
    field :bio, :string
    field :crawled_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%Band{} = band, attrs) do
    band
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
