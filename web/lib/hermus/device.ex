defmodule Hermus.Device do
  use GenServer

  alias Hermus.DevicesRegistry
  alias Hermus.Repo
  alias Hermus.Models

  def start_link(device_id) do
    GenServer.start_link(__MODULE__, device_id, name: DevicesRegistry.via_tuple(device_id))
  end

  def add_probe(probe, device_id) do
    device_id
    |> DevicesRegistry.via_tuple()
    |> GenServer.cast({:add_probe, probe})
  end

  def child_spec(device_id) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [device_id]},
      restart: :transient
    }
  end

  @impl true
  def init(device_id) do
    {:ok, device_id, {:continue, :upsert_device}}
  end

  @impl true
  def handle_cast({:add_probe, probe}, device_id) do
    probe =
      %Models.Probe{}
      |> Models.Probe.changeset(%{pm10: probe["pm10"], pm25: probe["pm25"]})
      |> Repo.insert!()

    Phoenix.PubSub.broadcast(Hermus.PubSub, "probe", probe)

    {:noreply, device_id}
  end

  @impl true
  def handle_continue(:upsert_device, device_id) do
    %Models.Device{}
    |> Models.Device.changeset(%{identifier: device_id})
    |> Repo.insert!(on_conflict: :nothing)

    {:noreply, device_id}
  end
end
