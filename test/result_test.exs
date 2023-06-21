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

  test "error/2" do
    assert Monads.Result.error(:not_found, :get_user) == {:error, :not_found, :get_user}
    assert Monads.Result.error({:error, :not_found}, :get_user) == {:error, :not_found, :get_user}
    assert Monads.Result.error(fn -> :not_found end, :get_user) == {:error, :not_found, :get_user}
    assert Monads.Result.error(fn -> {:error, :not_found} end, :get_user) == {:error, :not_found, :get_user}
    assert {:error, :not_found, :get_user} |> Monads.Result.error(:save_user) == {:error, :not_found, :get_user}
  end

  describe "map/2" do
    test "everything is ok" do
      assert "user"
             |> Monads.Result.ok()
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
             end)
             |> Monads.Result.map(:saved) ==
               {:ok, :saved}
    end

    test "something goes wrong" do
      assert "user"
             |> Monads.Result.ok()
             |> Monads.Result.map(fn r ->
               assert r == "user"
               {:ok, 1}
             end)
             |> Monads.Result.map(fn r ->
               assert r == 1
               {:error, :not_found}
             end)
             |> Monads.Result.map(fn _r -> :should_not_happen end) == {:error, :not_found}
    end
  end

  describe "map/3" do
    test "everything is ok" do
      assert "user"
             |> Monads.Result.ok()
             |> Monads.Result.map(:get_user, fn r ->
               assert r == "user"
               {:ok, 1}
             end)
             |> Monads.Result.map(:get_profile, fn r ->
               assert r == 1
               2
             end)
             |> Monads.Result.map(:notify_user, fn r ->
               assert r == 2
               {:ok, 1, 2, 3}
             end)
             |> Monads.Result.map(:save_user, fn r ->
               assert r == {1, 2, 3}
               r
             end)
             |> Monads.Result.map(:saved) ==
               {:ok, :saved}
    end

    test "something goes wrong" do
      assert "user"
             |> Monads.Result.ok()
             |> Monads.Result.map(:get_user, fn r ->
               assert r == "user"
               {:ok, 1}
             end)
             |> Monads.Result.map(:get_profile, fn r ->
               assert r == 1
               {:error, :not_found}
             end)
             |> Monads.Result.map(:notify_user, fn _r -> :should_not_happen end) == {:error, :not_found, :get_profile}
    end
  end
end
