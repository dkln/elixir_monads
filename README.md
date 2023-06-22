# Elixir Monads

## Result monad

Example:

    get_user()
    |> Monads.Result.map(:update_user, &update_user/1)
    |> Monads.Result.map(:notify, &create_notification_for_user/1)
    |> Monads.Result.restore(:update_user, nil)
    
    {:ok, %Notification{}} | {:error, term}