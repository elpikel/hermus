defmodule HermusWeb.DeviceController do
  use HermusWeb, :controller

  alias Hermus.AirQuality
  alias Hermus.AirQuality.Device

  action_fallback HermusWeb.FallbackController

  def index(conn, _params) do
    devices = AirQuality.list_devices()
    render(conn, "index.json", devices: devices)
  end

  def create(conn, %{"device" => device_params}) do
    with {:ok, %Device{} = device} <- AirQuality.create_device(device_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.device_path(conn, :show, device))
      |> render("show.json", device: device)
    end
  end

  def show(conn, %{"id" => id}) do
    device = AirQuality.get_device!(id)
    render(conn, "show.json", device: device)
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = AirQuality.get_device!(id)

    with {:ok, %Device{} = device} <- AirQuality.update_device(device, device_params) do
      render(conn, "show.json", device: device)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = AirQuality.get_device!(id)

    with {:ok, %Device{}} <- AirQuality.delete_device(device) do
      send_resp(conn, :no_content, "")
    end
  end
end
