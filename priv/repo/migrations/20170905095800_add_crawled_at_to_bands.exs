defmodule Khcpl.Repo.Migrations.AddCrawledAtToBands do
  use Ecto.Migration

  def change do
    alter table(:bands) do
      add :crawled_at, :utc_datetime
    end
  end
end
