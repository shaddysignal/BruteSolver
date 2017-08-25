defmodule Persar do
  @moduledoc """
  Will parse something like x * x + x + 1( = 0), variable is always some letter. Kind of in regex [a-z].
  Also probably parse x ^ 2 + 1( = 0). (...) - assume it is, always do mutation before giving it to Persar
  Also always place tactical spaces so the is no confusion
  """

  # operation to presence(some priority of execution, the higher the firstier)
  @op2pres %{"-": 0, "+": 0, "*": 1, "/": 1, "^": 2}
  # operations
  @ops ["-", "+", "*", "/", "^"]

  @doc """
  variables - List :: String
  notation - List :: Either(String, Float)
  orig - String
  """
  defstruct variables: [], notation: [], orig: ""

  def do_some(string) do
    variables = Regex.scan(~r/[a-z]/, string) |>
      Stream.map(&hd/1) |>
      Enum.uniq

    %Persar{variables: variables, notation: produce_notation(string), orig: string}
  end

  def produce_notation(string) do
    string |>
      String.split(" ") |>
      _produce_notation
  end


  # Parsing of original string to produce RPN(Reverse Polish Notation). Does not check for errors.
  # Probably produce some even.
  #
  # first  - list of operations or variables/numbers, essentially List :: String
  # second - stack(list) for notation generation, essentially List :: Either(String, Float)
  # third  - operation stack(list), esentually List :: String
  defp _produce_notation(list, notation \\ [], ostack \\ [])
  defp _produce_notation([], notation, []), do: Enum.reverse(notation)
  defp _produce_notation([], notation, [op | tail]), do: _produce_notation([], [op | notation], tail)
  defp _produce_notation([")" | tail], notation, [top_op | otail]) do
    cond do
      top_op === "(" -> _produce_notation(tail, notation, otail)
      true           -> _produce_notation([")" | tail], [top_op | notation], otail)
    end
  end
  defp _produce_notation(["(" | tail], notation, ostack), do: _produce_notation(tail, notation, ["(" | ostack])
  defp _produce_notation([op | tail], notation, []) when op in @ops, do: _produce_notation(tail, notation, [op])
  defp _produce_notation([op | tail], notation, [top_op | otail]) when op in @ops do
    case @op2pres[String.to_atom(top_op)] >= @op2pres[String.to_atom(op)] do
      true when op != "^" and top_op != "(" -> _produce_notation([op | tail], [top_op | notation], otail)
      _                                     -> _produce_notation(tail, notation, [op, top_op | otail])
    end
  end
  defp _produce_notation([not_op | tail], notation, ostack) do
    cond do
      String.match?(not_op, ~r/[a-z]/) -> _produce_notation(tail, [not_op | notation], ostack)
      true                             -> _produce_notation(tail, [elem(Float.parse(not_op), 0) | notation], ostack)
    end
  end

end