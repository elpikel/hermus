defmodule Hermus.DevicesRegistryTest do
  use Hermus.DataCase, async: false

  alias Hermus.Device
  alias Hermus.DevicesRegistry

  @device_identifier "Hermus.DevicesRegistryTest"

  test "device exists in registry" do
    Device.start_link(@device_identifier)

    assert DevicesRegistry.exist?(@device_identifier) == true
  end

  test "device does not exist in registry" do
    assert DevicesRegistry.exist?(@device_identifier) == false
  end
end
