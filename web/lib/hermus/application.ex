defmodule Hermus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Hermus.Repo,
      # Start the Telemetry supervisor
      HermusWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hermus.PubSub},
      # Start the Endpoint (http/https)
      HermusWeb.Endpoint,
      {Hermus.DevicesSupervisor, []},
      {Registry, [keys: :unique, name: Hermus.DevicesRegistry.name()]},
      {Hermus.UdpServer, 8680}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hermus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HermusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
