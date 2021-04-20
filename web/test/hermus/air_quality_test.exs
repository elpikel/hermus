defmodule Hermus.AirQualityTest do
  use Hermus.DataCase

  alias Hermus.AirQuality

  describe "devices" do
    alias Hermus.AirQuality.Device

    @valid_attrs %{ip: "some ip", name: "some name"}
    @update_attrs %{ip: "some updated ip", name: "some updated name"}
    @invalid_attrs %{ip: nil, name: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AirQuality.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert AirQuality.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert AirQuality.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = AirQuality.create_device(@valid_attrs)
      assert device.ip == "some ip"
      assert device.name == "some name"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AirQuality.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = AirQuality.update_device(device, @update_attrs)
      assert device.ip == "some updated ip"
      assert device.name == "some updated name"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = AirQuality.update_device(device, @invalid_attrs)
      assert device == AirQuality.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = AirQuality.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> AirQuality.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = AirQuality.change_device(device)
    end
  end
end
