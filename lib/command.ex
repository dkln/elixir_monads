defmodule Monads.Command do
  defstruct dependencies: [],
            fun: nil,
            id: nil

  @type t() :: %{dependences: list(), fun: function | nil, id: nil | atom}
end
