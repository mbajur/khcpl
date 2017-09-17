defmodule Khcpl.Repo.Migrations.AddUrlToBands do
  use Ecto.Migration

  def change do
    alter table(:bands) do
      add :url, :string, unique: true
    end
  end
end
