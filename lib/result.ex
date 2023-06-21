defmodule Monads.Result do
  defguard is_ok(value) when is_tuple(value) and elem(value, 0) == :ok
  defguard is_error(value) when is_tuple(value) and elem(value, 0) == :error
  defguard is_result(value) when is_ok(value) or is_error(value)

  @type t :: {:ok, term} | {:error, term}

  @spec ok(term) :: t
  def ok(value) when is_function(value), do: ok(value.())
  def ok(value) when is_result(value), do: value
  def ok(value), do: {:ok, value}

  @spec error(term) :: t
  def error(value) when is_function(value), do: error(value.())
  def error(value) when is_result(value), do: value
  def error(value), do: {:error, value}

  @spec new(term) :: t
  def new(value) when is_result(value), do: value
  def new(value) when is_function(value), do: new(value.())
  def new(value), do: ok(value)

  def map(value, func) when is_ok(value) and is_function(func) do
    value
    |> tuple_value()
    |> func.()
    |> ok()
  end

  @spec tuple_value(tuple | term) :: term
  def tuple_value(value) when is_tuple(value),
    do: if(tuple_size(value) == 2, do: elem(value, 1), else: Tuple.delete_at(value, 0))

  def tuple_value(value), do: value
end
