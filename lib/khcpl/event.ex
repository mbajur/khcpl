defmodule Khcpl.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Khcpl.Event


  schema "events" do
    field :facebook_id, :integer
    field :name, :string
    field :description, :string
    field :crawled_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:facebook_id])
    |> validate_required([:facebook_id])
  end
end
