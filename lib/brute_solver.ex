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

  def solve(brute, string) do
    %Persar{notation: notaiton, variables: vars} = Persar.do_some(string)

    {:ok, [solution | _]} =
      brute.init(notaiton, vars |> Enum.reduce([], fn _, acc -> [{-1000, 1000} | acc] end), 0.0005, vars)

    solution
  end

  @doc """
  Probably should be only 2 variables. But if one, then second assumed 0, if more then two, then they thrown away
  """
  def solve_and_draw(brute, string) do
    radius = 10
    dimension = 2000
    half_dimension = div(dimension, 2)
    strokeColor = "black"
    historyColor = "RGBA(0, 255, 255, 0.5)"
    solutionColor = "RGBA(255, 0, 0, 1)"

    %Persar{notation: notaiton, variables: vars} = Persar.do_some(string)

    {:ok, [solution | history]} =
      brute.init(
        notaiton,
        vars |> Enum.reduce([], fn _, acc -> [{-half_dimension, half_dimension} | acc] end), 0.0005, vars)

    circles = history |>
      Enum.map(&(transform_point(&1, radius))) |>
      Enum.map(fn {x, y, r} -> {x + half_dimension, y + half_dimension, r} end) |>
      Enum.reverse

    name = notaiton |> Enum.reduce("", fn e, acc -> "#{acc}#{e}" end)

    temp = %Mogrify.Image{path: "#{name}.png", ext: "png"} |>
      Mogrify.custom("size", "#{dimension}x#{dimension}") |>
      Mogrify.canvas("none") |>
      Mogrify.custom("fill", historyColor) |>
      Mogrify.custom("stroke", strokeColor) |>
      Mogrify.custom("strokewidth", 2)

    temp = circles |> Enum.reduce(temp, fn {x, y, radius}, acc -> acc |> Mogrify.Draw.circle(x, y, x, y + radius) end)

    [sx, sy | _] = solution |> Enum.map(&(&1 + half_dimension))

    image = temp |>
      Mogrify.custom("fill", solutionColor) |>
      Mogrify.Draw.circle(sx, sy, sx, sy + radius) |>
      Mogrify.create(path: ".")

    {:ok, IO.inspect(image)}
  end

  defp transform_point([x, y | _], radius), do: {x, y, radius}
  defp transform_point([x | tail], radius), do: transform_point([x, 0 | tail], radius)

end
