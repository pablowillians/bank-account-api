defmodule BankAccountWeb.UserController do
  use BankAccountWeb, :controller

  alias BankAccount.Accounts
  alias BankAccount.Accounts.User

  alias BankAccount.Guardian

  action_fallback BankAccountWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      render(conn, "jwt.json", jwt: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        render(conn, "jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end
end
