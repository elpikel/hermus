defmodule Hermus.NameTest do
  use Hermus.DataCase

  alias Hermus.Devices

  describe "add_device/1" do
    test "adds device" do
      device = Devices.add_device("new")

      assert device.identifier == "new"
      assert device.name != nil
    end

    test "updates device with the same id" do
      device = Devices.add_device("new")
      updated_device = Devices.add_device("new")

      assert device.name == updated_device.name
    end
  end
end
