defmodule Hermus.Devices do
  alias Hermus.Models
  alias Hermus.Name
  alias Hermus.Repo

  import Ecto.Query

  def add_device(device_id) do
    name = Name.generate()

    %Models.Device{}
    |> Models.Device.changeset(%{identifier: device_id, name: name})
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:name]},
      conflict_target: [:identifier],
      returning: true
    )
  end

  def add_probe(device_id, probe) do
    %Models.Probe{}
    |> Models.Probe.changeset(%{device_id: device_id, pm10: probe["pm10"], pm25: probe["pm25"]})
    |> Repo.insert!()
  end

  def list_probes() do
    Models.Probe
    |> from(as: :probe)
    |> limit(20)
    |> Repo.all()
  end
end
