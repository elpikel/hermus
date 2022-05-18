defimpl Jason.Encoder, for: Hermus.Models.Probe do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:device_id, :pm25, :pm10]), opts)
  end
end
