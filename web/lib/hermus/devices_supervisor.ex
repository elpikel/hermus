defmodule Hermus.DevicesSupervisor do
  use DynamicSupervisor
  alias Hermus.Device

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(device_id) do
    child_specification = {Device, device_id}

    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
