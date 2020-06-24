defmodule BankAccountWeb.AccountController do
  use BankAccountWeb, :controller

  alias BankAccount.Accounts
  alias BankAccount.Accounts.Account

  action_fallback BankAccountWeb.FallbackController

  @doc """
  Endpoint to create or update an account

  POST Json payload sample:

  ```
  {
    "account": {
      "cpf": "99999999999",
      "name": "Name Last Name",
      "email": "email@valid.com",
      "birth_date": "1991-01-29",
      "city": "Curitiba",
      "country": "BR",
      "gender": "male",
      "state": "PR",
      "indication_referral_code": "883632"
    }
  }
  ```

  RESPONSE Json payload sample

  ```
  {
    "data": {
      "birth_date": "1991-01-29",
      "city": "Curitiba",
      "country": "BR",
      "cpf": "99999999999",
      "email": "email@valid.com",
      "gender": "male",
      "id": "930f0dd5-9994-4655-8132-a640931b34bb",
      "indication_referral_code":"883632",
      "inserted_at": "2020-06-24T00:19:16",
      "name": "Name Last Name",
      "referral_code": "326388",
      "state": "PR",
      "status": true
    },
    "message": "Account created successfully. Referral code: 326388"
  }
  ```
  """
  def create_or_update(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_or_update_account(account_params) do
      is_account_full_filled = Accounts.is_account_full_filled?(account)

      view = unless is_account_full_filled, do: "show.json", else: "account_complete.json"
      status = unless is_account_full_filled, do: :success, else: :created

      conn
      |> put_status(status)
      |> render(view, account: account)
    end
  end

  def create_or_update(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("error.json", error: %{account: ["is required"]})
  end
end
