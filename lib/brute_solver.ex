defmodule BruteSolver do
  @moduledoc """
  Some attempt to create solver for n-equations, of course there will be parser for said equation.
  """

  def benchmark_brutes(brutes, string) do
    %Persar{notation: notation, variables: vars} = Persar.do_some(string)

    brutes |>
      Enum.map(fn brute ->
        IO.inspect("#{brute} getting ready... Go!")

        time = Time.utc_now()
        brute.init(notation, vars |> Enum.reduce([], fn _, acc -> [{-1000, 1000} | acc] end), 0.0005, vars)
        Time.diff(Time.utc_now(), time, :microsecond)
      end)
  end

  def solve(string) do
    %Persar{notation: notaiton, variables: vars} = Persar.do_some(string)

    {:ok, [solution | history]} =
      IntelligentBrute.init(notaiton, vars |> Enum.reduce([], fn _, acc -> [{-1000, 1000} | acc] end), 0.0005, vars)

    solution
  end
end
