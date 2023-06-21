defmodule Monads.ResultTest do
  use ExUnit.Case

  test "ok/1" do
    assert Monads.Result.ok(1337) == {:ok, 1337}
    assert Monads.Result.ok({:ok, 1337}) == {:ok, 1337}
    assert Monads.Result.ok(fn -> 1337 end) == {:ok, 1337}
    assert Monads.Result.ok(fn -> {:ok, 1337} end) == {:ok, 1337}
  end

  test "error/1" do
    assert Monads.Result.error(:not_found) == {:error, :not_found}
    assert Monads.Result.error({:error, :not_found}) == {:error, :not_found}
    assert Monads.Result.error(fn -> :not_found end) == {:error, :not_found}
    assert Monads.Result.error(fn -> {:error, :not_found} end) == {:error, :not_found}
  end

  describe "map/2" do
    test "everything is ok" do
      assert "user"
             |> Monads.Result.new()
             |> Monads.Result.map(fn r ->
               assert r == "user"
               {:ok, 1}
             end)
             |> Monads.Result.map(fn r ->
               assert r == 1
               2
             end)
             |> Monads.Result.map(fn r ->
               assert r == 2
               {:ok, 1, 2, 3}
             end)
             |> Monads.Result.map(fn r ->
               assert r == {1, 2, 3}
               r
             end) ==
               {:ok, {1, 2, 3}}
    end

    test "something goes wrong" do
      assert "user"
             |> Monads.Result.new()
             |> Monads.Result.map(fn r ->
               assert r == "user"
               {:ok, 1}
             end)
             |> Monads.Result.map(fn r ->
               assert r == 1
               {:error, :not_found}
             end) == {:error, :not_found}
    end
  end
end
