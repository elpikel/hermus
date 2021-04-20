defmodule HermusWeb.DeviceView do
  use HermusWeb, :view
  alias HermusWeb.DeviceView

  def render("index.json", %{devices: devices}) do
    %{data: render_many(devices, DeviceView, "device.json")}
  end

  def render("show.json", %{device: device}) do
    %{data: render_one(device, DeviceView, "device.json")}
  end

  def render("device.json", %{device: device}) do
    %{id: device.id,
      name: device.name,
      ip: device.ip}
  end
end
