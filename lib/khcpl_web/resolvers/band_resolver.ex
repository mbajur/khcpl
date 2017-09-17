defmodule Khcpl.BandResolver do
  def all(_args, _info) do
    {:ok, Khcpl.Repo.all(Khcpl.Band)}
  end
end
