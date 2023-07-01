defmodule Monads.Multi do
  alias __MODULE__
  alias Monads.{Command, Result}

  defstruct commands: []

  @type t :: %Multi{commands: list(Command.t())}

  @spec verify(t()) :: Result.t()
  def verify(%Multi{} = multi) do
    commands = Enum.with_index(multi.commands)

    result =
      commands
      |> Enum.map(fn {command, index} ->
        unique_id =
          command.id == nil ||
            Enum.find(commands, fn {other_command, other_index} ->
              index != other_index && other_command.id == command.id
            end) == nil

        missing_dependency =
          if Enum.empty?(command.dependencies) do
            nil
          else
            Enum.find(command.dependencies, fn id ->
              Enum.find(commands, fn {other_command, other_index} ->
                index != other_index && id == other_command.id
              end) == nil
            end)
          end

        cond do
          !unique_id -> {:error, ":#{command.id} is not unique"}
          missing_dependency -> {:error, ":#{missing_dependency} is an unknown dependency"}
          true -> :ok
        end
      end)

    if Enum.any?(result, &Result.error?/1) do
      Enum.find(result, &Result.error?/1)
    else
      {:ok, multi}
    end
  end

  @spec new() :: t()
  def new, do: %Multi{}

  @spec map(Multi.t(), function) :: Multi.t()
  def map(%Multi{} = multi, fun), do: %Multi{multi | commands: [%Command{fun: fun} | multi.commands]}

  @spec map(Multi.t(), atom, function) :: Multi.t()
  def map(%Multi{} = multi, id, fun), do: %Multi{multi | commands: [%Command{fun: fun, id: id} | multi.commands]}

  @spec map(Multi.t(), atom, list(atom), function) :: Multi.t()
  def map(%Multi{} = multi, id, dependencies, fun),
    do: %Multi{multi | commands: [%Command{dependencies: dependencies, fun: fun, id: id} | multi.commands]}

  @spec run(t()) :: Result.t()
  def run(%Multi{}) do
  end
end
