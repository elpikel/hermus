defimpl Jason.Encoder, for: Hermus.Probe do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:pm25, :pm10]), opts)
  end
end
