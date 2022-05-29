defimpl Jason.Encoder, for: Hermus.Models.Probe do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:device_id, :pm25, :pm10, :inserted_at]), opts)
  end
end

defimpl Jason.Encoder, for: Hermus.Models.Device do
  def encode(value, opts) do
    Jason.Encode.map(Map.take(value, [:id, :identifier, :name, :probes]), opts)
  end
end
