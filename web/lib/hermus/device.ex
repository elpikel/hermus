defmodule Hermus.Device do
  use GenServer

  alias Hermus.Devices
  alias Hermus.DevicesRegistry

  def start_link(device_identifier) do
    GenServer.start_link(__MODULE__, device_identifier,
      name: DevicesRegistry.via_tuple(device_identifier)
    )
  end

  def add_probe(probe, device_identifier) when not is_nil(probe) do
    device_identifier
    |> DevicesRegistry.via_tuple()
    |> GenServer.cast({:add_probe, probe})
  end

  def child_spec(device_identifier) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [device_identifier]},
      restart: :transient
    }
  end

  @impl true
  def init(device_identifier) do
    %{id: device_id} = Devices.add_device(device_identifier)

    {:ok, device_id}
  end

  @impl true
  def handle_cast({:add_probe, probe}, device_id) do
    probe = Devices.add_probe(device_id, probe)

    Phoenix.PubSub.broadcast(Hermus.PubSub, "probe", probe)

    {:noreply, device_id}
  end
end
