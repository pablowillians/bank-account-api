defmodule BankAccount.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BankAccount.Repo

  alias BankAccount.Accounts.Account


  @doc """
  Gets a single account, filtered by cpf field.

  Returns `nil` if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_account_by_cpf(123)
      %Account{}

      iex> get_account_by_cpf(456)
      nil

  """
  def get_account_by_cpf(cpf) when not is_nil(cpf), do: Repo.get_by(Account, cpf: Account.encrypt_value(cpf))

  def get_account_by_cpf(cpf) when is_nil(cpf), do: nil

  @doc """
  Gets a single account, filtered by cpf field.

  Returns `nil` if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_account_by_cpf(123)
      %Account{}

      iex> get_account_by_cpf(456)
      nil

  """
  def get_account_by_referral_code(referral_code), do: Repo.get_by(Account, referral_code: referral_code)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
    |> add_referral_code_if_account_complete()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
    |> add_referral_code_if_account_complete()
  end

  defp add_referral_code_if_account_complete({:ok, %Account{} = account} = success_tuple) do
    with true <- is_nil(account.referral_code),
        true <- is_account_full_filled?(account)
      do
      attrs = %{}
        |> Map.put(:referral_code, generate_unused_referral_code())
        |> Map.put(:status, true)

      Account.changeset(account, attrs)
      |> Repo.update()
    else
      _ -> success_tuple
    end
  end

  defp add_referral_code_if_account_complete({:error, _} = error_tuple), do: error_tuple

  @doc """
  Try to update an account, if not exists creates the account.

  ## Examples

      iex> create_or_update_account(%{field: new_value})
      {:ok, %Account{}}

      iex> create_or_update_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_or_update_account(attrs \\ %{}) do
    case get_account_by_cpf(attrs["cpf"]) do
      nil -> create_account(attrs)
      %Account{} = account -> update_account(account, attrs)
    end
  end

  @doc """
  Check if all account fields are filled

  ## Examples

      iex> is_account_full_filled(account_full_filled)
      true

      iex> is_account_full_filled(account_not_full_filled)
      false

  """
  def is_account_full_filled?(%Account{} = account) do
    with false <- account.status do
      account
      |> Map.delete(:referral_code)
      |> Map.delete(:indication_referral_code)
      |> Map.values()
      |> Enum.any?(fn value -> not is_nil(value) end)
    end
  end

  @doc """
  Recursive function to generate an unused referral code

  ## Examples

      iex> generate_unused_referral_code()
      "17283456"

  """
  def generate_unused_referral_code() do
    referral_code = generate_random_numeric_string()

    get_account_by_referral_code(referral_code)
    |> generate_unused_referral_code(referral_code)
  end

  defp generate_unused_referral_code(%Account{} = _account, _referral_code) do
    referral_code = generate_random_numeric_string()

    get_account_by_referral_code(referral_code)
    |> generate_unused_referral_code(referral_code)
  end

  defp generate_unused_referral_code(account, referral_code) when is_nil(account) do
    referral_code
  end

  defp generate_random_numeric_string() do
    10_000_000..99_999_999
    |> Enum.random()
    |> Integer.to_string()
  end

  defdelegate decrypt_value(value), to: Account
end
