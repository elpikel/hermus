defmodule Hermus.UdpServer do
  use GenServer

  alias Hermus.DevicesRegistry
  alias Hermus.DevicesSupervisor
  alias Hermus.Device

  def start_link(port \\ 8680) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    {:ok, network_info} = :inet.getif()
    {_ip_address, broadcast_address, _} = find_local(network_info)

    {:ok, socket} = :gen_udp.open(port, [:binary, active: true, broadcast: true])

    {:ok, %{socket: socket, broadcast_address: broadcast_address}, {:continue, :init}}
  end

  def handle_continue(:init, state) do
    send(self(), :ask_for_data)

    {:noreply, state}
  end

  def handle_info(
        :ask_for_data,
        %{socket: socket, broadcast_address: broadcast_address} = state
      ) do
    :gen_udp.send(socket, broadcast_address, 8681, "ping")

    Process.send_after(self(), :ask_for_data, 1_000)

    {:noreply, state}
  end

  def handle_info({:udp, _socket, _address, _port, data}, state) do
    %{"device_id" => device_id, "probe" => probe} = Jason.decode!(data)

    if !DevicesRegistry.exist?(device_id) do
      DevicesSupervisor.start_child(device_id)
    end

    Device.add_probe(probe, device_id)

    {:noreply, state}
  end

  defp find_local(networks) do
    Enum.find(networks, fn {_, broadcast_address, _} -> broadcast_address != :undefined end)
  end
end
