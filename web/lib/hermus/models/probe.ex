defmodule Hermus.Models.Probe do
  use Ecto.Schema

  import Ecto.Changeset

  alias Hermus.Models.Device

  schema "probes" do
    field :pm10, :float
    field :pm25, :float

    belongs_to :device, Device

    timestamps(type: :utc_datetime)
  end

  def changeset(probe, params \\ %{}) do
    probe
    |> cast(params, [:pm10, :pm25])
    |> validate_required([:pm10, :pm25])
  end
end
