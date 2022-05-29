defmodule HermusWeb.ProbeLive.Index do
  use HermusWeb, :live_view

  alias Hermus.Devices
  alias Hermus.Models

  @probes_limit 20

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Hermus.PubSub, "probe")
    end

    {:ok, assign(socket, :devices, list_devices())}
  end

  @impl true
  def handle_info(%Models.Probe{} = probe, socket) do
    handle_new_probe(probe, socket)
  end

  defp handle_new_probe(probe, socket) do
    devices = socket.assigns.devices

    updated_devices =
      update_in(devices[probe.device_id], fn device ->
        probes =
          device.probes
          |> add(probe)
          |> window()

        %{device | probes: probes}
      end)

    socket = assign(socket, devices: updated_devices)

    {:noreply, push_event(socket, "probe", %{probe: probe})}
  end

  defp add(probes, probe) do
    [probe | probes]
  end

  defp window(probes) do
    Enum.take(probes, @probes_limit)
  end

  defp list_devices() do
    @probes_limit
    |> Devices.list()
    |> Enum.into(%{}, fn device ->
      {device.id, device}
    end)
  end
end
