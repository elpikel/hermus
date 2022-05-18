defmodule Hermus.Repo.Migrations.AddProbesTable do
  use Ecto.Migration

  def change do
    create table("probes") do
      add :pm10, :float
      add :pm25, :float
      add :device_id, references("devices")

      timestamps(type: :utc_datetime)
    end
  end
end
