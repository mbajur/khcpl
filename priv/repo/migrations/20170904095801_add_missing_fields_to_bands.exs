defmodule Khcpl.Repo.Migrations.AddMissingFieldsToBands do
  use Ecto.Migration

  def change do
    alter table(:bands) do
      add :photo_url, :string
      add :location, :string
      add :bio, :text
    end
  end
end
