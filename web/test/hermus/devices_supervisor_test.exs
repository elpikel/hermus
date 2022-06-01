defmodule Hermus.DevicesSupervisorTest do
  use Hermus.DataCase, async: false

  alias Hermus.DevicesSupervisor

  test "starts device" do
    assert {:ok, _pid} = DevicesSupervisor.start_child(Ecto.UUID.generate())
  end

  test "does not start the same device twice" do
    device_identifier = Ecto.UUID.generate()

    assert {:ok, pid} = DevicesSupervisor.start_child(device_identifier)

    assert {:error, {:already_started, pid}} == DevicesSupervisor.start_child(device_identifier)
  end
end
