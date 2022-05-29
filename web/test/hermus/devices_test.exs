defmodule Hermus.NameTest do
  use Hermus.DataCase

  alias Hermus.Devices

  describe "add_device/1" do
    test "adds device" do
      device = Devices.add_device("new")

      assert device.identifier == "new"
      assert device.name != nil
    end

    test "does not update device with the same id" do
      device = Devices.add_device("new")
      updated_device = Devices.add_device("new")

      assert device.name == updated_device.name
    end
  end

  describe "list_probes/0" do
    test "gets devices with 20 limited probes" do
      device1 = Devices.add_device("1")
      device2 = Devices.add_device("2")

      add_probes(device1)
      add_probes(device2)

      [%{identifier: "1"} = device1, %{identifier: "2"} = device2] = Devices.list_probes()

      assert length(device1.probes) == 20
      assert length(device2.probes) == 20

      assert Enum.at(device1.probes, 0).pm10 == 40.0
      assert Enum.at(device2.probes, 0).pm10 == 40.0

      assert Enum.at(device1.probes, 19).pm10 == 21.0
      assert Enum.at(device2.probes, 19).pm10 == 21.0
    end
  end

  defp add_probes(device) do
    inserted_at = DateTime.utc_now()

    Enum.each(1..40, fn index ->
      number = :rand.uniform(100)

      probe = Devices.add_probe(device.id, %{"pm10" => index, "pm25" => number * index})

      inserted_at =
        inserted_at
        |> DateTime.add(index, :second)
        |> DateTime.truncate(:second)

      probe
      |> Ecto.Changeset.change(inserted_at: inserted_at)
      |> Repo.update!()
    end)
  end
end
