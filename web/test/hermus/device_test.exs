defmodule Hermus.DeviceTest do
  use Hermus.DataCase, async: false

  alias Hermus.Device
  @device_identifier "Hermus.DeviceTest"

  setup do
    %{device_pid: start_supervised!({Device, @device_identifier})}
  end

  test "adds device to db when started" do
    device =
      Models.Device
      |> from(as: :device)
      |> where([device: d], d.identifier == ^@device_identifier)
      |> limit(1)
      |> Repo.one()

    assert device.identifier == @device_identifier
  end

  test "adds probe" do
    Device.add_probe(%{"pm10" => 2.2, "pm25" => 3.3}, @device_identifier)

    device =
      Models.Device
      |> from(as: :device)
      |> where([device: d], d.identifier == ^@device_identifier)
      |> limit(1)
      |> Repo.one()

    probe =
      Models.Probe
      |> from(as: :probe)
      |> where([probe: p], p.device_id == ^device.id)
      |> limit(1)
      |> Repo.one()

    assert probe.device_id == device.id
    assert probe.pm10 == 2.2
    assert probe.pm25 == 3.3
  end
end
