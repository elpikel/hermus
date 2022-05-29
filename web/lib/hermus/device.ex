defmodule Hermus.Device do
  use GenServer

  alias Hermus.Devices
  alias Hermus.DevicesRegistry

  def start_link(device_id) do
    GenServer.start_link(__MODULE__, device_id, name: DevicesRegistry.via_tuple(device_id))
  end

  def add_probe(probe, device_id) when not is_nil(probe) do
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
    probe = Devices.add_probe(device_id, probe)

    Phoenix.PubSub.broadcast(Hermus.PubSub, "probe", probe)

    {:noreply, device_id}
  end

  @impl true
  def handle_continue(:upsert_device, device_id) do
    %{id: device_id} = Devices.add_device(device_id)

    {:noreply, device_id}
  end
end
