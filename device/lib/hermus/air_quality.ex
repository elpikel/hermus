defmodule Hermus.AirQuality do
  use GenServer

  alias Hermus.SDS011

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{last_probe: nil}, name: __MODULE__)
  end

  def last_probe() do
    GenServer.call(__MODULE__, :last_probe)
  end

  @impl true
  def init(state) do
    {:ok, pid} = Circuits.UART.start_link()
    Circuits.UART.open(pid, port(), active: true)

    {:ok, state}
  end

  @impl true
  def handle_call(:last_probe, _from, state) do
    {:reply, state.last_probe, state}
  end

  @impl true
  def handle_info({:circuits_uart, _usb, message}, state) do
    probe = SDS011.decode!(message)

    state = %{state | last_probe: probe}

    {:noreply, state}
  end

  defp port() do
    Circuits.UART.enumerate()
    |> Enum.find(fn {_key, value} -> value != %{} end)
    |> then(fn
      {port, _} -> port
      _ -> nil
    end)
  end
end
