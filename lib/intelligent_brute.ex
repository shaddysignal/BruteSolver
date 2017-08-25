defmodule IntelligentBrute do
  @moduledoc """
  Following advice from some matematictian, this brute will make more intellegent guesses when solving
  """

  import Acros

  @doc """
  notation - List :: Either(String, Float)
  limits - List :: {Integer, Integer}
  precision - Float
  variables - List :: String
  line - List :: List :: Float. Only 2 elements(on the first level), start and end points.
  """
  defstruct notation: [], limits: [], precision: 0.5, variables: [], line: []

  def init(notation, limits, precision, variables) do
    loop(%IntelligentBrute{notation: notation, limits: limits, precision: precision, variables: variables})
  end

  def loop(brute) do
    _loop(brute)
  end

  # First one is with defaults, but in best java traditions
  defp _loop(brute) do
    _loop(1, [], %IntelligentBrute{brute | line: _find_points(brute)})
  end
  defp _loop(val, history, %IntelligentBrute{precision: precision}) when inside_precision(val, precision),
       do: {:ok, history}
  defp _loop(_, history, brute) do
    # calculating new point
    mean_point = brute.line |>
      Stream.zip |>
      Enum.map(fn {lx, rx} -> (rx + lx) / 2 end)

    # calibrating scope of search
    new_val = _execute(brute.notation, brute.variables, mean_point)
    [lp, rp] = brute.line

    _loop(
      new_val,
      [mean_point | history],
      %IntelligentBrute{brute | line: cond do: (new_val > 0 -> [lp, mean_point]; new_val < 0 -> [mean_point, rp])}
    )
  end

  # Finding points in different areas, i.e. in a way that for first one val < 0 and val > 0 for second one
  defp _find_points(brute) do
    [_find_point(_generate_point(brute.limits), -1, brute), _find_point(_generate_point(brute.limits), 1, brute)]
  end

  defp _find_point(point, sign, brute) do
    cond do
      sign(_execute(brute.notation, brute.variables, point)) === sign(sign) -> point
      true -> _find_point(_generate_point(brute.limits), sign, brute)
    end
  end

  defp _generate_point(limits) do
    limits |>
      Enum.map(fn {l, r} -> :rand.uniform() * (r - l) + l end)
  end

  defp _execute(notation, vars, for_point) do
    Stream.zip(vars, for_point) |>
      Enum.reduce(
        notation,
        fn ({var, val}, acc) -> acc |> Enum.map(fn el -> cond do: (el === var -> val; true -> el) end) end
      ) |>
      Executor.execute
  end

end
