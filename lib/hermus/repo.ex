defmodule Hermus.Repo do
  use Ecto.Repo,
    otp_app: :hermus,
    adapter: Ecto.Adapters.Postgres
end
