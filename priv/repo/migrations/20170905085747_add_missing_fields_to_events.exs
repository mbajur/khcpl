defmodule Khcpl.Repo.Migrations.AddMissingFieldsToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :name, :string
      add :description, :text
    end
  end
end
