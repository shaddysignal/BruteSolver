defmodule RandomBrute do
  @moduledoc """
  Simple and stupid brute, that do some point-and-shoot without any regard where he shooting. Just random.
  """
  import Acros

  @doc """
  notation - List :: Either(String, Integer)
  variables - List :: String
  limits - List :: {Integer, Integer}
  precistion - Float
  """
  defstruct notation: [], variables: [], limits: [], precision: 0.5

  def init(notation, limits, precision, variables) do
    loop(%RandomBrute{notation: notation, variables: variables, limits: limits, precision: precision})
  end

  def loop(brute) do
    _loop(brute)
  end

  defp _loop(val \\ 1, history \\ [], brute)
  defp _loop(val, history, %RandomBrute{precision: precision}) when inside_precision(val, precision), do: {:ok, history}
  defp _loop(_, history, brute = %RandomBrute{variables: vars, limits: limits, notation: notation}) do
    point_in_space = limits |>
      Enum.map(fn {l, r} -> :rand.uniform() * (r - l) + l end)
    value = Stream.zip(vars, point_in_space) |>
      Enum.reduce(
        notation,
        fn ({var, val}, acc) -> acc |> Enum.map(fn el -> cond do: (el === var -> val; true -> el) end) end
      ) |>
      Executor.execute

    _loop(value, [point_in_space | history], brute)
  end

end