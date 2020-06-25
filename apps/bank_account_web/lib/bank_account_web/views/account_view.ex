defmodule BankAccountWeb.AccountView do
  use BankAccountWeb, :view
  alias BankAccountWeb.AccountView
  alias BankAccount.Accounts

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account_complete.json", %{account: account}) do
    %{message: "Account created successfully. Referral code: #{account.referral_code}",
      data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    name = if is_nil(account.name), do: nil, else: Accounts.decrypt_value(account.name)
    email = if is_nil(account.email), do: nil, else: Accounts.decrypt_value(account.email)
    cpf = if is_nil(account.cpf), do: nil, else: Accounts.decrypt_value(account.cpf)
    birth_date = if is_nil(account.birth_date), do: nil, else: Accounts.decrypt_value(account.birth_date)

    %{id: account.id,
      name: name,
      email: email,
      cpf: cpf,
      birth_date: birth_date,
      gender: account.gender,
      city: account.city,
      state: account.state,
      country: account.country,
      referral_code: account.referral_code,
      indication_referral_code: account.indication_referral_code,
      status: account.status,
      inserted_at: account.inserted_at}
  end

  def render("indications.json", %{indications: indications}) do
    %{data: render_many(indications, AccountView, "indication.json")}
  end

  def render("indication.json", %{account: indication}) do
    %{id: indication.id,
      name: Accounts.decrypt_value(indication.name)
    }
  end
end
