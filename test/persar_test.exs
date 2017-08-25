defmodule PersarTest do
  use ExUnit.Case
  doctest Persar

  test "do_some produce %Persar" do
    %Persar{variables: vars, notation: notation} = Persar.do_some("x + 1")

    assert vars == ["x"]
    assert notation == ["x", 1, "+"]
  end

  test "produce_notation produce, well, notation" do
    notation = Persar.produce_notation("x + 1")

    assert notation == ["x", 1, "+"]
  end
end
