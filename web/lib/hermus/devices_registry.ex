defmodule Hermus.DevicesRegistry do
  @name :devices_registry

  def name do
    @name
  end

  def via_tuple(device_id) do
    {:via, Registry, {@name, device_id}}
  end

  def exist?(device_id) do
    Registry.lookup(@name, device_id) != []
  end
end
