defmodule Acros do
  @moduledoc """
  All the macros that will be needed
  """

  defmacro inside_precision(val, precision) do
    quote do: unquote(val) >= 0 and unquote(val) < unquote(precision) or
      unquote(val) < 0 and -unquote(val) < unquote(precision)
  end

  def sign(val) do
    cond do
      val < 0  -> -1
      val == 0 -> 0
      val > 0  -> 1
    end
  end
  
end