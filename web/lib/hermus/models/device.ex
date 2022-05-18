defmodule Hermus.Models.Device do
  use Ecto.Schema

  import Ecto.Changeset

  alias Hermus.Models.Probe

  schema "devices" do
    field :identifier, :string
    field :name, :string

    has_many :probes, Probe

    timestamps(type: :utc_datetime)
  end

  def changeset(device, params \\ %{}) do
    device
    |> cast(params, [:identifier, :name])
    |> validate_required([:identifier])
    |> unique_constraint([:identifier, :name])
  end
end
