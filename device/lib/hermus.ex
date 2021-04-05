defmodule Hermus do
  use GenServer

  @impl true
  def init(_args) do
    IO.inspect(Circuits.UART.enumerate())

    {:ok, pid} = Circuits.UART.start_link()

    {:ok, pid}
  end
end
