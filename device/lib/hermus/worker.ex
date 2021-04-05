defmodule Hermus.Worker do
  use GenServer

  alias Hermus.SDS011

  @impl true
  def init(pid) do
    Circuits.UART.open(pid, port(), active: true)
    {:ok, pid}
  end

  def start_link(_args) do
    {:ok, pid} = Circuits.UART.start_link()
    GenServer.start_link(__MODULE__, pid)
  end

  @impl true
  def handle_info({:circuits_uart, _usb, message}, pid) do
    _probe = SDS011.decode!(message) |> IO.inspect()

    {:noreply, pid}
  end

  defp port() do
    {port, _} = Enum.find(Circuits.UART.enumerate(), fn {_key, value} -> value != %{} end)

    port
  end
end
