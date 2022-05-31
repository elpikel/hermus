defmodule Hermus.DevicesRegistry do
  @name :devices_registry

  def name do
    @name
  end

  def via_tuple(device_identifier) do
    {:via, Registry, {@name, device_identifier}}
  end

  def exist?(device_identifier) do
    Registry.lookup(@name, device_identifier) != []
  end
end
