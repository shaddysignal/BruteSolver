defmodule BruteMaster.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(arg) do
    children = [
      worker(RandomBrute, [arg], restart: :temporary)
    ]

    supervise(children, strategy: :one_for_one)
  end
end