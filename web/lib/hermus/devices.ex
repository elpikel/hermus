defmodule Hermus.Devices do
  alias Hermus.Models
  alias Hermus.Repo

  import Ecto.Query

  def add_device(device_id) do
    %Models.Device{}
    |> Models.Device.changeset(%{identifier: device_id})
    |> Repo.insert!(on_conflict: :nothing)
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
