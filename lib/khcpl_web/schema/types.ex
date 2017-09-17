defmodule Khcpl.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation
  use Absinthe.Ecto, repo: Khcpl.Repo

  node object :band do
    field :name, :string
    field :location, :string
    field :bio, :string
    field :photo_url, :string
    field :crawled_at, :string
  end

  node object :event do
    field :name, :string
    field :description, :string
    field :crawled_at, :string
  end
end
