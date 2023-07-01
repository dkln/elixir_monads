defmodule Monads.MultiTest do
  use ExUnit.Case

  alias Monads.{Command, Multi}

  test "new/0" do
    assert Multi.new() == %Multi{}
  end

  describe "verify/1" do
    test "correct" do
      multi = %Multi{}

      assert Multi.verify(multi) == {:ok, multi}

      multi = %Multi{commands: [%Command{}, %Command{id: :download}, %Command{id: :upload}]}

      assert Multi.verify(multi) == {:ok, multi}

      multi = %Multi{
        commands: [
          %Command{},
          %Command{id: :download},
          %Command{id: :upload},
          %Command{id: :verify, dependencies: [:download, :upload]}
        ]
      }

      assert Multi.verify(multi) == {:ok, multi}
    end

    test "duplicate id" do
      multi = %Multi{commands: [%Command{}, %Command{id: :download}, %Command{id: :download}]}
      assert Multi.verify(multi) == {:error, ":download is not unique"}
    end

    test "missing dependency" do
      multi = %Multi{
        commands: [
          %Command{},
          %Command{id: :download},
          %Command{id: :upload},
          %Command{dependencies: [:download, :upload, :verify]}
        ]
      }

      assert Multi.verify(multi) == {:error, ":verify is an unknown dependency"}
    end
  end
end
