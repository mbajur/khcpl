defmodule Khcpl.Repo.Migrations.AddCrawledAtToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :crawled_at, :utc_datetime
    end
  end
end
