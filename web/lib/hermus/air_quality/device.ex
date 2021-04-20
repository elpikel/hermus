defmodule Hermus.AirQuality.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :ip, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :ip])
    |> validate_required([:name, :ip])
  end
end
