defmodule Hermus.Repo.Migrations.AddDevicesTable do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :identifier, :string, size: 40
      add :name, :string, size: 100

      timestamps(type: :utc_datetime)
    end

    create unique_index(:devices, [:identifier, :name])
  end
end
