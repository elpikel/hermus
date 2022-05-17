defmodule Hermus.UdpClient do
  use GenServer

  alias Hermus.AirQuality

  def start_link(port \\ 8681) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    :gen_udp.open(port, [:binary, active: true, broadcast: true])
  end

  def handle_info({:udp, socket, address, port, "ping"}, state) do
    probe = AirQuality.last_probe()

    :gen_udp.send(
      socket,
      address,
      port,
      Jason.encode!(%{device_id: Application.fetch_env!(:hermus, :id), probe: probe})
    )

    {:noreply, state}
  end
end
