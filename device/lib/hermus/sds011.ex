defmodule Hermus.SDS011 do
  alias Hermus.Probe
  defmodule UnsupportedMessageError, do: defexception([:message])

  @header <<0xAA, 0xC0>>
  @trailer 0xAB

  def decode!(<<@header::binary, d1, d2, d3, d4, d5, d6, checksum, @trailer>>)
      when rem(d1 + d2 + d3 + d4 + d5 + d6, 256) == checksum do
    %Probe{
      pm25: (d2 * 256 + d1) / 10,
      pm10: (d4 * 256 + d3) / 10
    }
  end

  def decode!(<<@header::binary, _::size(48), checksum, @trailer>>) do
    raise UnsupportedMessageError, "Wrong checksum: #{inspect(checksum)}"
  end

  def decode!(message) do
    raise UnsupportedMessageError, "Unrecognized message: #{inspect(message)}"
  end
end
