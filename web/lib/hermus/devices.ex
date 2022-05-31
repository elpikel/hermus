defmodule Hermus.Devices do
  alias Hermus.Models
  alias Hermus.Name
  alias Hermus.Repo

  import Ecto.Query

  def add_device(device_identifier) do
    name = Name.generate()

    %Models.Device{}
    |> Models.Device.changeset(%{identifier: device_identifier, name: name})
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:id, :name]},
      conflict_target: [:identifier],
      returning: true
    )
  end

  def add_probe(device_id, probe) do
    %Models.Probe{}
    |> Models.Probe.changeset(%{device_id: device_id, pm10: probe["pm10"], pm25: probe["pm25"]})
    |> Repo.insert!()
  end

  def list(limit \\ 20) do
    limited_query =
      Models.Probe
      |> from(as: :limited_probe)
      |> select([limited_probe: p], %{
        id: p.id,
        row_number: over(row_number(), :devices_partition)
      })
      |> windows(devices_partition: [partition_by: :device_id, order_by: [desc: :inserted_at]])

    probes_query =
      Models.Probe
      |> from(as: :probe)
      |> join(
        :inner,
        [probe: p],
        lq in subquery(limited_query),
        on: p.id == lq.id and lq.row_number <= ^limit
      )

    Models.Device
    |> from(as: :device)
    |> preload(probes: ^probes_query)
    |> Repo.all()
  end
end
