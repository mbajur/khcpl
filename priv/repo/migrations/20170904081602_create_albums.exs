defmodule Khcpl.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string
      add :url, :string
      add :band_id, references(:band, on_delete: :nothing)

      timestamps()
    end

    create index(:albums, [:band_id])
  end
end
