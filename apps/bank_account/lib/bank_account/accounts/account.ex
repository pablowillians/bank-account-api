defmodule BankAccount.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Brcpfcnpj.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :birth_date, :string
    field :city, :string
    field :country, :string
    field :cpf, :string
    field :email, :string
    field :gender, :string
    field :name, :string
    field :indication_referral_code, :string
    field :referral_code, :string
    field :state, :string
    field :status, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :email, :cpf, :birth_date, :gender, :city, :state, :country, :indication_referral_code, :referral_code, :status])
    |> validate_required([:cpf])
    |> validate_cpf(:cpf)
    |> validate_format(:email, ~r/@/)
    |> encrypt_field(:cpf)
    |> encrypt_field(:name)
    |> encrypt_field(:email)
    |> encrypt_field(:birth_date)
    |> unique_constraint(:cpf, name: :cpf_unique)
    |> unique_constraint(:referral_code, name: :referral_code_unique)
  end

  defp encrypt_field(%Ecto.Changeset{} = changeset, field_name) do
    case get_change(changeset, field_name) do
      nil -> changeset
      value -> put_change(changeset, field_name, encrypt_value(value))
    end
  end

  @doc """
  Encrypt the specified value

  ## Examples

      iex> encrypt_value("1234")
      "xTzpT4"

  """
  def encrypt_value(value) do
    Base.encode64(value, padding: false)
  end

  @doc """
  Decrypt the specified value

  ## Examples

      iex> encrypt_value("xTzpT4")
      "1234"

  """
  def decrypt_value(value) do
    with {:ok, decrypted_value} <- Base.decode64(value, padding: false) do
      decrypted_value
    end
  end
end
