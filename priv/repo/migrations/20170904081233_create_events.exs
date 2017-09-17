defmodule Khcpl.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :facebook_id, :integer

      timestamps()
    end

  end
end
