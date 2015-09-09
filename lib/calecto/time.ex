defmodule Calecto.Time do
  require Calendar.Time
  import Calecto.Utils

  @moduledoc """
  Calendar Time for Ecto
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :time

  @doc """
  Times are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Casts to time.
  """
  def cast(<<hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) do
    if usec(rest) do
      from_parts(to_i(hour), to_i(min), to_i(sec))
    else
      :error
    end
  end
  def cast(%Calendar.Time{} = t),
    do: {:ok, t}
  def cast(%{"hour" => hour, "min" => min, "sec" => sec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec))
  def cast(%{"hour" => hour, "min" => min}),
    do: from_parts(to_i(hour), to_i(min), 0)
  def cast({hour, min, sec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec))
  def cast({hour, min, sec, usec}),
    do: from_parts(to_i(hour), to_i(min), to_i(sec), to_i(usec))
  def cast(_),
    do: :error

  defp from_parts(hour, min, sec) do
    Calendar.Time.from_erl({hour, min, sec})
  end
  defp from_parts(hour, min, sec, usec) do
    Calendar.Time.from_erl({hour, min, sec}, usec)
  end

  @doc """
  Converts an `Ecto.Time` into a time tuple.
  """
  def dump(%Calendar.Time{} = time) do
    {:ok, Calendar.Time.to_micro_erl(time)}
  end

  @doc """
  Converts a time tuple into an `Ecto.Time`.
  """
  def load({hour, min, sec}) do
    Calendar.Time.from_erl({hour, min, sec})
  end

  def load({hour, min, sec, usec}) do
    Calendar.Time.from_erl({hour, min, sec}, usec)
  end
end
