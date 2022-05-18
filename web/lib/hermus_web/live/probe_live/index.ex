defmodule HermusWeb.ProbeLive.Index do
  use HermusWeb, :live_view

  alias Hermus.Devices
  alias Hermus.Models

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Hermus.PubSub, "probe")
    end

    {:ok, assign(socket, :probes, list_probes())}
  end

  @impl true
  def handle_info(%Models.Probe{} = probe, socket) do
    handle_new_probe(probe, socket)
  end

  defp handle_new_probe(probe, socket) do
    probes =
      socket.assigns.probes
      |> add(probe)
      |> window()

    socket = assign(socket, probes: probes)

    {:noreply, push_event(socket, "probes", %{probes: probes})}
  end

  defp add(probes, probe) do
    [probe | probes]
  end

  defp window(probes) do
    Enum.take(probes, 20)
  end

  defp list_probes do
    Devices.list_probes()
  end
end
