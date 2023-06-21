defmodule Monads.Result do
  defguard is_ok(value) when is_tuple(value) and elem(value, 0) == :ok
  defguard is_error(value) when is_tuple(value) and elem(value, 0) == :error
  defguard is_result(value) when is_ok(value) or is_error(value)

  @type t :: {:ok, term} | {:error, term} | {:error, atom, term}

  @spec ok(term) :: t
  def ok(value) when is_function(value), do: ok(value.())
  def ok(value) when is_result(value), do: value
  def ok(value), do: {:ok, value}

  @spec ok(term, atom) :: t
  def ok(value, context) when is_function(value) and is_atom(context), do: ok(value.(), context)
  def ok(value, context) when is_ok(value) and is_atom(context), do: value
  def ok(value, context) when is_error(value) and is_atom(context), do: error(value, context)
  def ok(value, context) when is_atom(context), do: value

  @spec error(term) :: t
  def error(value) when is_function(value), do: error(value.())
  def error(value) when is_result(value), do: value
  def error(value), do: {:error, value}

  @spec error(term, atom) :: t
  def error(value, context) when is_function(value) and is_atom(context), do: error(value.(), context)

  def error(value, context) when is_result(value) and is_atom(context) do
    if tuple_size(value) == 2 do
      {:error, tuple_value(value), context}
    else
      value
    end
  end

  def error(value, context), do: {:error, value, context}

  @spec map(t, function | term) :: t
  def map(value, func) when is_ok(value) and is_function(func) do
    value
    |> tuple_value()
    |> func.()
    |> ok()
  end

  def map(value, _func) when is_error(value), do: error(value)

  def map(_value, new_value), do: ok(new_value)

  @spec map(t, atom, function | term) :: t
  def map(value, context, _func) when is_error(value), do: error(value, context)

  def map(value, context, func) when is_atom(context) and is_function(func) do
    value
    |> tuple_value()
    |> func.()
    |> ok(context)
  end

  @spec tuple_value(tuple | term) :: term
  def tuple_value(value) when is_tuple(value),
    do: if(tuple_size(value) == 2, do: elem(value, 1), else: Tuple.delete_at(value, 0))

  def tuple_value(value), do: value
end
