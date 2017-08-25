defmodule Executor do
  @moduledoc """
  Executor for RPN stack
  """

  def execute(notation) do
    _parse(notation) |> _execute
  end

  # Seen that at rosseta code, seem legit to do it that way
  defp _parse(notation, stack \\ [])
  defp _parse([], result), do: Enum.reverse(result)
  defp _parse(["+" | notation], stack), do: _parse(notation, [fn(l, r) -> l + r end | stack])
  defp _parse(["-" | notation], stack), do: _parse(notation, [fn(l, r) -> l - r end | stack])
  defp _parse(["*" | notation], stack), do: _parse(notation, [fn(l, r) -> l * r end | stack])
  defp _parse(["/" | notation], stack), do: _parse(notation, [fn(l, r) -> l / r end | stack])
  defp _parse(["^" | notation], stack), do: _parse(notation, [fn(l, r) -> :math.pow(l, r) end | stack])
  defp _parse([n | notation], stack) when is_number(n), do: _parse(notation, [n | stack])

  # The whole thing to execute. Buckle up, it does not check for errors
  #
  # first  - RPN(reverse polish notation), essentially List :: Either(String, Float)
  # second - stack for execution, essentially List :: Either(String, Float)
  defp _execute(notation, stack \\ [])
  defp _execute([], [result | []]), do: result
  defp _execute([n | notation], stack) when is_number(n), do: _execute(notation, [n | stack])
  defp _execute([f | notation], [nr, nl | stack]), do: _execute(notation, [f.(nl, nr) | stack])

end