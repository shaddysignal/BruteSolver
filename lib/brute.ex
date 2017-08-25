defmodule Brute do
  @moduledoc false

  use GenServer

  # Client

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(opts = %{type: type}) do
    type.init()

    {:ok, %{}}
  end

  # Server (callbacks)

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end