defmodule BankAccount.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BankAccount.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BankAccount.PubSub}
      # Start a worker by calling: BankAccount.Worker.start_link(arg)
      # {BankAccount.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BankAccount.Supervisor)
  end
end
