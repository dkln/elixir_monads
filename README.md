# Elixir Monads

## Result monad

Example:

    get_user()
    |> Monads.Result.map(&update_user/1)
    |> Monads.Result.map(&create_notification_for_user/1)
    
    {:ok, %Notification{}} | {:error, term}